import './style/index.scss'

const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')

const accepted = () => {
    if (process.env.NODE_ENV === 'production') {
        (function (i, s, o, g, r, a, m) {
            i['GoogleAnalyticsObject'] = r
            i[r] = i[r] || function () {
                (i[r].q = i[r].q || []).push(arguments)
            }, i[r].l = 1 * new Date()
            a = s.createElement(o), m = s.getElementsByTagName(o)[0]
            a.async = 1
            a.src = g
            m.parentNode.insertBefore(a, m)
        })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga')

        ga('create', 'UA-41262245-3', 'auto')
        ga('set', 'anonymizeIp', true)
        ga('send', 'pageview')
    }
}

pagesInit({
    mainElmModule: Elm.Main
}).then(app => {
    const cookieName = 'jt-cookies'
    const expirationDays = 30

    const cookie = document.cookie.match(`(^| )${cookieName}=([^;]+)`)
    if (cookie && cookie[2]) {
        app.ports.cookieState.send(JSON.parse(cookie[2]))
        accepted()
    } else {
        app.ports.cookieState.send({accept: false})
    }

    app.ports.cookieAccept.subscribe((state) => {
        if (state.accept) {
            const date = new Date()
            date.setTime(date.getTime() + (expirationDays * 24 * 60 * 60 * 1000))
            document.cookie = cookieName + '=' + JSON.stringify(state) + '; expires=' + date.toUTCString() + '; path=/; SameSite=None; Secure'
            accepted()
        }
    })

    app.ports.pageChange.subscribe((url) => {
        if (typeof ga === 'function') {
            ga('set', 'page', url)
            ga('send', 'pageview')
        }
    })
})