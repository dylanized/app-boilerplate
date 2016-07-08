# App Name

App description goes here.

## Quick Info

#### Dev

- URL: 
- DB: 
- Log: 

#### Staging

- URL: 
- DB: 
- Log: 
- Deploy:

#### Production

- URL: 
- DB: 
- Log:
- Deploy:

## Tasks

#### Building

- `npm install`
  - Installs NPM and Bower modules, then runs the build
- `npm update`
  - Updates NPM and Bower modules
- `npm run build`
  - Compile assets, do anything else needed
- `npm run compile`
  - Compile all assets
- `npm run css:compile`
  - Compile CSS
- `npm run js:compile`
  - Compile JS
  
#### Watching

- `npm run watch`
  - Launch all watch scripts
- `npm run css:watch`
  - Watch CSS source and compile on change
- `npm run js:watch`
  - Watch JS source and compile on change
- `npm run server:watch`
  - Watch compiled assets and restart server on change

#### Running  
  
- `npm start`
  - Starts server and master process
- `npm run build:start`
  - Runs the build and starts server
- `npm run watch:start`
  - Laucnh watch scripts and start the server 
- `npm run dev`
  - Reload db, run the build, then watch:start
- `npm stop`
  - Shut down databases
- `npm restart`
  - Stop then start again
  
#### Testing  
  
- `npm test`
  - Runs active Mocha test files
  - Stops after first failure
  - Suppresses NPM error messages
- `npm run mocha`
  - Runs all Mocha test files
  - Does not bail after failures
  - Optionally add `-- --bail` or other arguments
  - Displays NPM error messages
- `npm run mocha test/1*.js`
  - Runs a subset of test files
- `npm run test-grep <term>`
  - Run tests that have a name that matches `<term>`
  - Optionally add `-- --bail` 
- `npm run env`
  - Print out NPM environment variables
- `npm run bin`
  - Show installed binaries
  
#### Database Tasks 
  
- `npm run db:create`
  - Creates the database
- `npm run db:import <file>`
  - Imports file to database
- `npm run db:seed`
  - Imports seed file to database (defined in `package.json`)
- `npm run db:drop`
  - Drops database
- `npm run db:reload`
  - Executes `npm run db:drop && npm run seedDB`
- `npm run db:export <file>`
  - Exports database to `<file>`
- `npm run db:start`
  - Starts database process
- `npm run db:stop`
  - Stops database process
- `npm run db:destroy`
  - Destroy database
  
#### 2nd Database Tasks 
  
- `npm run sql:create`
- `npm run sql:import <file>`
- `npm run sql:seed`
- `npm run sql:drop`
- `npm run sql:reload`
- `npm run sql:export <file>`
- `npm run sql:start`
- `npm run sql:stop`
- `npm run sql:destroy`

#### Cleanup Tasks  

- `npm run clean`
  - Delete temp files
- `npm uninstall`
  - Destroy databases and delete temp files
  
#### Other Tasks  

- `npm run cron`
  - Maintenance task that is run regularly
- `npm run archive`
  - Occasional archive task

## Architecture Notes

#### Section #1

- note #1
- note #2

#### Section #2

- note #1
- note #2

## Devops Notes

#### Cron Jobs

**Cron Job #1**

- details
  
**Cron Job #2**

- details

#### Build System

- step #1
- step #2

## User Roles

#### Role #1

#### Role #2

## API Endpoints

#### Endpoint Group #1

| Name        | Path                |
| ----------- | ------------------- |
| Endpoint #1 | `/path/to/endpoint` |
| Endpoint #2 | `/path/to/endpoint` |

**Details**

- Path: /link
- Request type: POST
- Content: form-encoded data

**Fields**

- field #1
- field #2

**Result**

- Content-Type: application/json
- Content:
	- prop #1
	- prop #2
	
## Setup	
	
#### App Dependencies

- dep #1
- dep #2

#### Dev Dependencies

- dep #1
- dep #2

#### Dev Install

1.
2.
3.

#### Dev Routine

1.
2.

#### Useful Dev Links

- http://a.com
- http://b.com

#### Staging Install

1.
2.
3.
4.
5.

#### Production Install

1.
2.
3.

## Database Details

For basic tasks, Tasks section above.

Other database actions:

#### Get Access

#### Create User

## Tests

| Name         | Details |
| ------------ | ------- |
| Test File #1 | details |
| Test File #2 | details |

To run tests, see Tasks section above. 

To deactivate tests, prefix the filename with an underscore.

## Credits

Main contributors:

- Contributor #1
- Contributor #2

(c) 2016 App Author