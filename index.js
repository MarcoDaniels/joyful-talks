import './style/index.css'

const {Elm} = require('./src/Main.elm')
const pagesInit = require('elm-pages')

pagesInit({
    mainElmModule: Elm.Main
})