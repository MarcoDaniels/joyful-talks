import {Aws, Options} from 'aws-cli-js'
import path from "path"

const aws = new Aws(new Options(
    process.env.AWS_ACCESS_KEY_ID,
    process.env.AWS_SECRET_ACCESS_KEY,
))

const output = path.join(`${__dirname}/../dist/`)
const bucket = `s3://${process.env.AWS_S3_BUCKET}`

aws.command(`s3 sync ${output} ${bucket}`).then(() => {
    console.log(`🚀  app deployed`)
})