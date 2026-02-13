// SERVER-SIDE(Node.js with ws library)

import WebSocket, { WebSocketServer } from 'ws'

const wss = new WebSocketServer({ port:8080 })

wss.on('connection', (socket) => {
    console.log('Client connected')

    socket.on('message', (message) =>{
        wss.clients.forEach(client => {
            if(client.readyState === WebSocket.OPEN){
                client.send(message.toString())
            }
        })
    })

    socket.on('close', () => {
        console.log('Client disconnected')
    })
})

//Client (browser)

const socket = new WebSocket('ws://localhost:8080')

socket.onopen = () => {
    console.log('Connedted to server')
}

socket.onmessage = (event) => {
    console.log('New message', event.data)
}

function sendMessage(msg){
    socket.send(msg)
}


// 📤 Flow:
// User → Browser → WebSocket → Server → All Clients

// WebSocket.CONNECTING (0)
// WebSocket.OPEN (1)
// WebSocket.CLOSING (2)
// WebSocket.CLOSED (3)


// WebSocket sends data in frames:

// Text frame
// Binary frame
// Close frame
// Ping/Pong frame


// 📤 Complete Real-World Architecture:
// User A
//    ↓
// Browser
//    ↓
// WebSocket Client
//    ↓
// WebSocket Server
//    ↓
// Backend Logic
//    ↓
// Database
//    ↓
// WebSocket Server
//    ↓
// Other Users


////***EXPLANATION****////

// This code creates a WebSocket server using the ws library in Node.js. 
// When a client connects, a persistent TCP connection is established after the HTTP upgrade handshake.
// When a client sends a message, the server receives it and broadcasts it to all connected clients using wss.clients.
// The connection remains open until either side closes it, enabling real-time bidirectional communication.