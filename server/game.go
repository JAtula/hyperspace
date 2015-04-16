package main

import (
	"encoding/json"
	"log"
	"strconv"
	"time"
)

type Game struct {
	// Registered clients.
	clients map[*Client]bool

	// Register requests from the clients.
	register chan *Client

	// Unregister requests from clients.
	unregister chan *Client

	// Inbound events from the clients/AIs.
	events chan *Event

	// Game objects that currently exist
	players     map[string]*PlayerData
	projectiles map[string]*ProjectileData

	// Next valid game object id.
	nextId int
}

type GameError struct {
	What string
}

func (e GameError) Error() string {
	return e.What
}

const (
	updatePeriod = 100 * time.Millisecond
)

// TODO get this working without a global variable, I guess pass a ref to game into the web socket handler function?
var game = Game{
	clients:     make(map[*Client]bool),
	register:    make(chan *Client),
	unregister:  make(chan *Client),
	events:      make(chan *Event),
	players:     make(map[string]*PlayerData),
	projectiles: make(map[string]*ProjectileData),
}

func (g *Game) run() {
	ticker := time.NewTicker(updatePeriod)
	defer func() {
		ticker.Stop()
	}()

	for {
		select {
		case c := <-g.register:
			// register client
			g.clients[c] = true

			// create player
			g.nextId++
			id := strconv.Itoa(g.nextId)
			p := &PlayerData{id, 256, 110}
			g.players[p.Id] = p

			// send initial player data
			c.Initialize(id, g.fullState())
		case c := <-g.unregister:
			if _, ok := g.clients[c]; ok {
				delete(g.clients, c)
			}

			// TODO mark the player as dead, and then after a time, delete them from the list of players
			// delete(g.players, c.playerId)
		case e := <-g.events:
			err := g.applyEvent(e)
			if err != nil {
				log.Println("Error applying event", e, err)
				continue
			}
		case <-ticker.C:
			g.broadcastUpdate()
		}
	}
}

func (g *Game) applyEvent(e *Event) error {
	switch e.Type {
	case "position":
		data := e.Data.(*PlayerData)
		p := g.players[data.Id]
		if p == nil {
			return GameError{"Player doesn't exist"}
		}

		// move the player
		p.X = data.X
		p.Y = data.Y
		return nil
	case "fire":
		data := e.Data.(*FireData)

		// create a projectile and spawn goroutine to move it forward (TODO switch to game loop)
		pos := &PositionData{X: 0, Y: 0}
		projectile := ProjectileData{Id: data.Id, Angle: 0, Position: pos}
		g.projectiles[projectile.Id] = &projectile
		go func() {
			for i := 0; i < 1000; i++ {
				projectile.UpdateOneTick()
				g.broadcastUpdate()
				time.Sleep(time.Duration(25) * time.Millisecond)
			}
		}()
		return nil
	default:
		return GameError{"Don't know how to apply event"}
	}

}

func (g *Game) fullState() *UpdateData {
	return &UpdateData{g.players, g.projectiles}
}

func (g *Game) broadcastUpdate() {
	data := g.fullState()
	b, err := json.Marshal(data)
	if err != nil {
		panic(err)
	}

	raw := json.RawMessage(b)
	m := &Message{"update", &raw}

	for c := range g.clients {
		c.Send(m)
	}
}