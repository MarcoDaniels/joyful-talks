import got, {Got} from 'got'
import {config} from './config'

// TODO: cockpit client should be extracted to shared library (re-use in cockpit-type)

const baseClient: Got = got.extend({
    prefixUrl: config.cockpitAPIURL,
    headers: {
        'Content-Type': 'application/json',
        'Cockpit-Token': config.cockpitAPIToken,
    },
    responseType: 'json',
    mutableDefaults: true,
    handlers: [
        (options, next) => {
            if (options.isStream) return next(options)

            return (async () => {
                try {
                    return await next(options)
                } catch (error) {
                    const {response} = error

                    let errorMessage = `${options.method} cockpit-type`

                    if (response) {
                        console.error(`Error fetching: ${options.url.pathname}`)
                        errorMessage += ` ${response.statusCode} - ${response.statusMessage}`
                    }

                    throw Error(errorMessage)
                }
            })()
        },
    ],
})

export type ResponseError = {
    success: false
    message: string
}

export type ResponseSuccess<T> = {
    success: true
    data: T
}

export type ResponseResult<T> = Promise<ResponseSuccess<T> | ResponseError>

const baseCockpitClient = <T>(url: string): ResponseResult<T> =>
    new Promise((resolve) =>
        baseClient
            .get<T>(url)
            .then((res) => resolve({success: true, data: res.body}))
            .catch((err) => resolve({success: false, message: err.toString()})),
    )

export const cockpitClient = {
    collections: (): ResponseResult<string[]> =>
        baseCockpitClient<string[]>(`collections/listCollections`),
    collectionData: <T>(id: string): ResponseResult<T> =>
        baseCockpitClient<T>(`collections/entries/${id}?populate=5`),
    singletons: (): ResponseResult<string[]> =>
        baseCockpitClient<string[]>(`singletons/listSingletons`),
    singletonData: <T>(id: string): ResponseResult<T> =>
        baseCockpitClient<T>(`singletons/get/${id}?populate=5`),
}