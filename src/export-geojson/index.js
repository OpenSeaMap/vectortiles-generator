#!/usr/bin/env node
'use strict'

let fs = require('fs')
var dbgeo = require('dbgeo')
var pg = require('pg')
var geojsonhint = require('geojsonhint')

var program = require('commander')

var credentials = require('./credentials')

program
  .version('0.0.1')
  .option('--pg_user <user>', 'Postgres username', credentials.user)
  .option('--pg_passwort <pass>', 'Postgres passwort', credentials.passwort)
  .option('--pg_host <host>', 'Postgres host', credentials.host)
  .option('--pg_port <port>', 'Postgres port', credentials.port)
  .option('--pg_database <database>', 'Postgres database', credentials.database)
  .option('--pg_table <table>', 'Postgres table', credentials.table)
  .option('-f, --outFile <filename>', 'Output filename')
  .parse(process.argv)

credentials.user = program.pg_user || credentials.user
credentials.passwort = program.pg_passwort || credentials.passwort
credentials.host = program.pg_host || credentials.host
credentials.port = program.pg_port || credentials.port
credentials.database = program.pg_database || credentials.database
credentials.table = program.pg_table || credentials.table

let connectionString = 'postgres://' +
    credentials.user + ':' + credentials.passwort + '@' + credentials.host + ':' + credentials.port + '/' + credentials.database
console.log('Connecting to ' + connectionString)
var client = new pg.Client(connectionString)

// Connect to postgres
client.connect(function (error, success) {
  if (error) {
    console.log('Could not connect to postgres')
    process.exit(1)
  }
})

function outputJson (json) {
  if (program.outFile) {
    fs.writeFileSync(program.outFile, JSON.stringify(json))
    console.log('wrote data to file "' + program.outFile + '"')
  } else {
    console.log(JSON.stringify(json))
  }
}

client.query('SELECT ST_AsGeoJSON(ST_TRANSFORM(geometry,4674), 6) AS geometry, name, type FROM ' + credentials.table,
  function (error, result) {
    if (error) {
      console.log('error: ' + error)
      process.exit(4)
    }
    dbgeo.parse(result.rows, {
      geometryType: 'geojson',
      geometryColumn: 'geometry'
    }, function (error, result) {
      if (error) {
        console.log('error: ' + error)
        process.exit(2)
      } else {
        var errors = geojsonhint.hint(result)
        if (errors.length) {
          console.log('error: ' + errors)
          process.exit(3)
        } else {
        }

        outputJson(result)

        process.exit(0)
      }
    })
  })
