const express = require('express')
const dotenv=require('dotenv').config()
const port = 4040
const app = express()
const path=require('path')
const cors = require('cors')
const helmet = require('helmet')

const connectDb = require('./connection.js')
const Routers = require('./professorRouter.js')
const publicDirectoryPath=path.join(__dirname,'../public')
app.use(express.static(publicDirectoryPath))
app.use(express.json())
app.use(
  helmet({
    contentSecurityPolicy: false,
    xDownloadOptions: false,
  })
);
app.use(express.urlencoded({ extended: true }));


app.use('/professor', Routers)

connectDb().then(() => {
  app.listen(port, () => {
      console.log(`Server started at http://localhost:${port}`);
  });
}).catch((err) => {
  console.error('Unable to start server');
  process.exit(1);
});
