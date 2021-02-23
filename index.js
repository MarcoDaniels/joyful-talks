import './style/index.scss'

const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')


pagesInit({
    mainElmModule: Elm.Main
}).then(app => {
    // TODO: make it better
    const cookieName = 'jt-cookies'
    const expirationDays = 30
    const value = '; ' + document.cookie
    const parts = value.split('; ' + cookieName + '=')
    if (parts[1]) {
        app.ports.cookieState.send(JSON.parse(parts[1]))
    }

    app.ports.cookieAccept.subscribe((state) => {
        if (state.accept) {
            const date = new Date()
            date.setTime(date.getTime() + (expirationDays * 24 * 60 * 60 * 1000))
            document.cookie = cookieName + '=' + JSON.stringify(state) + '; expires=' + date.toUTCString() + '; path=/'
        }
    })
})