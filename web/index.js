const server = require("ws").Server
const s = new server({port: 5001})
s.on("connection", ws => {
    ws.on("message", message => {
        s.clients.forEach(c => {
            if (c !== ws) {
                c.send(message)
            }
        })
    })
})
