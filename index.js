import './style/index.scss'

const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')


pagesInit({
    mainElmModule: Elm.Main
}).then(app => {
    const cookieName = 'jt-cookies'
    const expirationDays = 30

    const cookie = document.cookie.match(`(^| )${cookieName}=([^;]+)`)
    if (cookie && cookie[2]) {
        app.ports.cookieState.send(JSON.parse(cookie[2]))
    } else {
        app.ports.cookieState.send({accept: false})
    }

    app.ports.cookieAccept.subscribe((state) => {
        if (state.accept) {
            const date = new Date()
            date.setTime(date.getTime() + (expirationDays * 24 * 60 * 60 * 1000))
            document.cookie = cookieName + '=' + JSON.stringify(state) + '; expires=' + date.toUTCString() + '; path=/'
        }
    })
})