import './style/index.scss'

const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')


pagesInit({
    mainElmModule: Elm.Main
}).then(app => {
    const cookieConsent = localStorage.getItem('jt-cookie')

    if (cookieConsent) {
        app.ports.cookieState.send(JSON.parse(cookieConsent))
    }

    app.ports.cookieAccept.subscribe((state) =>
        localStorage.setItem('jt-cookie', JSON.stringify(state))
    )
})