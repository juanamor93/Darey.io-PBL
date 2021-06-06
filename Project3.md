# PROJECT 3 - Simple To-Do application on MERN Web Stack
### MERN Web stack consists of following components:
1. MongoDB: A document-based, No-SQL database used to store application data in a form of documents.
1. ExpressJS: A server side Web Application framework for Node.js.
1. ReactJS: A frontend framework developed by Facebook. It is based on JavaScript, used to build User Interface (UI) components.
1. Node.js: A JavaScript runtime environment. It is used to run JavaScript on a machine rather than in a browser.

## Step 1 - Backend configuration
* Update ubuntu
```
sudo apt update
```
![sudo apt update](images/Project3/Project3-Step1-sudoaptupdate.png)
![sudo apt update2](images/Project3/Project3-Step1-sudoaptupdate2.png)


* Upgrade ubuntu
```
sudo apt upgrade
```
![sudo apt updgrade](images/Project3/Project3-Step1-sudoaptupgrade.png)

* Lets get the location of Node.js software from Ubuntu repositories.
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
```
![curl -sL](images/Project3/Project3-Step1-curl-sL.png)

## Install Node.js on the server
* Install Node.js with the command below
```
sudo apt-get install -y nodejs
```
![install nodejs](images/Project3/Project3-Step1-installnodejs.png)

* Verify the node installation with the command below
```
node -v
```
* Verify the npm installation with the command below
```
npm -v

```
![node version](images/Project3/Project3-Step1-nodeversion.png)

## Application Code Setup
* Create a new directory for your To-Do project:
```
$ mkdir Todo
```
* Run the command below to verify that the Todo directory is created with ls command
```
$ ls
```
* Now change your current directory to the newly created one:
```
$ cd Todo
```
![mkdir Todo](images/Project3/Project3-Step1-mkdirtodo.png)

Next, you will use the command ```npm init``` to initialise your project, so that a new file named ```package.json``` will be created. This file will normally contain information about your application and the dependencies that it needs to run.
* Follow the prompts after running the command. You can press Enter several times to accept default values, then accept to write out the package.json file by typing yes.

![npm init](images/Project3/Project3-Step1-npminit.png)

* Run the command ls to confirm that you have package.json file created.

![ls package](images/Project3/Project3-Step1-lspackage.png)

## Install ExpressJS
* To use express, install it using npm:
```
$ npm install express
```
![install express](images/Project3/Project3-Step1-installexpress.png)

* Now create a file `index.js` with the command below
```

$ touch index.js
```
* Run `ls` to confirm that your index.js file is successfully created

![touch index](images/Project3/Project3-Step1-touchindex.png)

* Install the `dotenv` module
```
npm install dotenv
```
![install dotenv](images/Project3/Project3-Step1-installdotenv.png)

* Open the index.js file with the command below
```
$ vim index.js
```
* Type the code below into it and save. Do not get overwhelmed by the code you see. For now, simply paste the code into the file.
```
const express = require('express');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use((req, res, next) => {
res.send('Welcome to Express');
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
```
![vim index](images/Project3/Project3-Step1-vimindex.png)

* Use `:w` to save in vim and use `:qa` to exit vim


Notice that we have specified to use port 5000 in the code. This will be required later when we go on the browser.

Now it is time to start our server to see if it works. 
* Open your terminal in the same directory as your index.js file and type:
```
$ node index.js
```
If every thing goes well, you should see Server running on port 5000 in your terminal.

![node index](images/Project3/Project3-Step1-nodeindex.png)

Now we need to open this port in EC2 Security Groups. There we created an inbound rule to open TCP port 80, you need to do the same for port 5000, like this:

![port 5000](images/Project3/Project3-Step1-port5000.png)

* Open up your browser and try to access your server’s Public IP or Public DNS name followed by port 5000:
```
http://<PublicIP-or-PublicDNS>:5000
```
![welcome page](images/Project3/Project3-Step1-welcomepage.png)

## Routes

#### There are three actions that our To-Do application needs to be able to do:
1. Create a new task
1. Display list of all tasks
1. Delete a completed task

* For each task, we need to create `routes` that will define various endpoints that the `To-do` app will depend on. So let us create a folder `routes`
```
$ mkdir routes
```
* Change directory to `routes` folder.
```
$ cd routes
```
* Now, create a file api.js with the command below
```
touch api.js
```
![mkdir routes](images/Project3/Project3-Step1-mkdirroutes.png)

* Open the file with the command below
```
vim api.js
```
* Copy below code in the file. (Do not be overwhelmed with the code)
```
const express = require ('express');
const router = express.Router();

router.get('/todos', (req, res, next) => {

});

router.post('/todos', (req, res, next) => {

});

router.delete('/todos/:id', (req, res, next) => {

})

module.exports = router;
```
![vim api](images/Project3/Project3-Step1-vimapi.png)

## Models
A model is at the heart of JavaScript based applications, and it is what makes it interactive.

We will also use models to define the database schema . This is important so that we will be able to define the fields stored in each Mongodb document.

To create a Schema and a model, install `mongoose` which is a Node.js package that makes working with mongodb easier.

* Change directory back Todo folder with `cd ..` and install Mongoose
```
$ npm install mongoose
```
![install mongoose](images/Project3/Project3-Step1-installmongoose.png)

* Create a new folder with `mkdir models` command
* Change directory into the newly created ‘models’ folder with `cd models`
* Inside the models folder, create a file and name it `todo.js`
```
mkdir models && cd models && touch todo.js
```
![mkdir models](images/Project3/Project3-Step1-mkdirmodels.png)

* Open the file created with `vim todo.js` then paste the code below in the file:
```
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//create schema for todo
const TodoSchema = new Schema({
action: {
type: String,
required: [true, 'The todo text field is required']
}
})

//create model for todo
const Todo = mongoose.model('todo', TodoSchema);

module.exports = Todo;
```
![vim todo](images/Project3/Project3-Step1-vimtodo.png)

Now we need to update our routes from the file `api.js` in ‘routes’ directory to make use of the new model.

* In Routes directory, open api.js with `vim api.js`, delete the code inside with `:%d` command and paste the code below into it then save and exit
```
const express = require ('express');
const router = express.Router();
const Todo = require('../models/todo');

router.get('/todos', (req, res, next) => {

//this will return all the data, exposing only the id and action field to the client
Todo.find({}, 'action')
.then(data => res.json(data))
.catch(next)
});

router.post('/todos', (req, res, next) => {
if(req.body.action){
Todo.create(req.body)
.then(data => res.json(data))
.catch(next)
}else {
res.json({
error: "The input field is empty"
})
}
});

router.delete('/todos/:id', (req, res, next) => {
Todo.findOneAndDelete({"_id": req.params.id})
.then(data => res.json(data))
.catch(next)
})

module.exports = router;
```
![vim api update](images/Project3/Project3-Step1-vimapiupdate.png)

## MongoDB Database
We need a database where we will store our data. For this we will make use of mLab. mLab provides MongoDB database as a service solution (DBaaS), so to make life easy, you will need to sign up for a shared clusters free account, which is ideal for our use case.

* Complete a get started checklist as shown on the image below

![checklist](images/Project3/Project3-Step1-checklist.png)

* Allow access to the MongoDB database from anywhere (Not secure, but it is ideal for testing)

![ip access](images/Project3/Project3-Step1-ipaccess.png)

* Create a MongoDB database and collection inside mLab

![collections](images/Project3/Project3-Step1-collections.png)

In the `index.js` file, we specified `process.env` to access environment variables, but we have not yet created this file. So we need to do that now.

* Create a file in your Todo directory and name it `.env`
```
touch .env
vi .env
```
* Add the connection string to access the database in it, just as below:
```
DB = 'mongodb+srv://<username>:<password>@<network-address>/<dbname>?retryWrites=true&w=majority'
```
![vi .env](images/Project3/Project3-Step1-vi.env.jpg)

Now we need to update the index.js to reflect the use of .env so that Node.js can connect to the database.

* Simply delete existing content in the file, and update it with the entire code below.
```
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const routes = require('./routes/api');
const path = require('path');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

//connect to the database
mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log(`Database connected successfully`))
.catch(err => console.log(err));

//since mongoose promise is depreciated, we overide it with node's promise
mongoose.Promise = global.Promise;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin", "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use(bodyParser.json());

app.use('/api', routes);

app.use((err, req, res, next) => {
console.log(err);
next();
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});
```
![index update](images/Project3/Project3-Step1-indexupdate.png)

Using environment variables to store information is considered more secure and best practice to separate configuration and secret data from the application, instead of writing connection strings directly inside the index.js application file.

* Start your server using the command:
```
node index.js
```

![start server](images/Project3/Project3-Step1-startserver.png)

You shall see a message ‘Database connected successfully’, if so - we have our backend configured. Now we are going to test it.

## Testing Backend Code without Frontend using RESTful API
In this project, we will use Postman to test our API.

You should test all the API endpoints and make sure they are working. For the endpoints that require body, you should send JSON back with the necessary fields since it’s what we setup in our code.

* Now open your Postman, create a POST request to the API `http://<PublicIP-or-PublicDNS>:5000/api/todos`. 

This request sends a new task to our To-Do list so the application could store it in the database.

![POST request](images/Project3/Project3-Step1-postrequest.png)

* Create a GET request to your API on `http://<PublicIP-or-PublicDNS>:5000/api/todos`.

 This request retrieves all existing records from out To-do application (backend requests these records from the database and sends it us back as a response to GET request).

![GET request](images/Project3/Project3-Step1-getrequest.png)

* Try to figure out how to send a DELETE request to delete a task from out To-Do list.

To delete a task - you need to send its ID as a part of DELETE request.

![DELETE request](images/Project3/Project3-Step1-deleterequest.png)

By now you have tested backend part of our To-Do application and have made sure that it supports all three operations we wanted:

1. Display a list of tasks - HTTP GET request
1. Add a new task to the list - HTTP POST request
1. Delete an existing task from the list - HTTP DELETE request

## Step 2 - Frontend creation
To start out with the frontend of the To-do app, we will use the create-react-app command to scaffold our app.

* In the same root directory as your backend code, which is the Todo directory, run:
```
$ npx create-react-app client
```
![create react app](images/Project3/Project3-Step2-createreactapp.png)

This will create a new folder in your `Todo` directory called `client`, where you will add all the react code.

## Running a React App
Before testing the react app, there are some dependencies that need to be installed.

* Install concurrently. It is used to run more than one command simultaneously from the same terminal window.
```
$ npm install concurrently --save-dev
```
* Install nodemon. It is used to run and monitor the server. If there is any change in the server code, nodemon will restart it automatically and load the new changes.
```
$ npm install nodemon --save-dev
```
![npm install](images/Project3/Project3-Step2-npminstall.png)

* In `Todo` folder open the `package.json` file. Change the highlighted part of the below screenshot and replace with the code below.

![package before](images/Project3/Project3-Step2-packagebefore.jpg)

```
"scripts": {
"start": "node index.js",
"start-watch": "nodemon index.js",
"dev": "concurrently \"npm run start-watch\" \"cd client && npm start\""
},
```
![package after](images/Project3/Project3-Step2-packageafter.png)

## Configure Proxy in `package.json`
* Change directory to ‘client’
```
cd client
```
* Open the package.json file
```
vim package.json
```
* Add the key value pair in the package.json file `"proxy": "http://localhost:5000"`.

![proxy](images/Project3/Project3-Step2-proxy.png)

* Now, ensure you are inside the Todo directory, and simply do:
```
npm run dev
```
![proxy](images/Project3/Project3-Step2-npmrundev.png)

Your app should open and start running on `localhost:3000`

## Creating your React Components
One of the advantages of react is that it makes use of components, which are reusable and also makes code modular. 
* For our Todo app, there will be two stateful components and one stateless component. From your `Todo` directory run:
```
cd client
```
* move to the `src` directory
```
cd src
```
* Inside your src folder create another folder called `components`
```
mkdir components
```
* Move into the `components` directory with:
```
cd components
```
Inside `components` directory create three files `Input.js`, `ListTodo.js` and `Todo.js`.
```
touch Input.js ListTodo.js Todo.js
```
![components](images/Project3/Project3-Step2-components.png)

* Open `Input.js` file
```
vim Input.js
```
* Copy and paste the following:
```
import React, { Component } from 'react';
import axios from 'axios';

class Input extends Component {

state = {
action: ""
}

addTodo = () => {
const task = {action: this.state.action}

    if(task.action && task.action.length > 0){
      axios.post('/api/todos', task)
        .then(res => {
          if(res.data){
            this.props.getTodos();
            this.setState({action: ""})
          }
        })
        .catch(err => console.log(err))
    }else {
      console.log('input field required')
    }

}

handleChange = (e) => {
this.setState({
action: e.target.value
})
}

render() {
let { action } = this.state;
return (
<div>
<input type="text" onChange={this.handleChange} value={action} />
<button onClick={this.addTodo}>add todo</button>
</div>
)
}
}

export default Input
```
![vim input](images/Project3/Project3-Step2-viminput.png)

To make use of Axios, which is a Promise based HTTP client for the browser and node.js, you need to cd into your client from your terminal and run yarn add axios or npm install axios.

* Move to the clients folder
```
cd ../..
```
* Install Axios
```
$ npm install axios
```
Go to `components` directory
```
cd src/components
```
![npm install axios](images/Project3/Project3-Step2-installaxios.png)

* After that open your `ListTodo.js`
```
vim ListTodo.js
```
* in the `ListTodo.js` copy and paste the following code:
```
import React from 'react';

const ListTodo = ({ todos, deleteTodo }) => {

return (
<ul>
{
todos &&
todos.length > 0 ?
(
todos.map(todo => {
return (
<li key={todo._id} onClick={() => deleteTodo(todo._id)}>{todo.action}</li>
)
})
)
:
(
<li>No todo(s) left</li>
)
}
</ul>
)
}

export default ListTodo
```
![vim listtodo.js](images/Project3/Project3-Step2-listtodo.png)

* Then in your `Todo.js` file you write the following code:
```
import React, {Component} from 'react';
import axios from 'axios';

import Input from './Input';
import ListTodo from './ListTodo';

class Todo extends Component {

state = {
todos: []
}

componentDidMount(){
this.getTodos();
}

getTodos = () => {
axios.get('/api/todos')
.then(res => {
if(res.data){
this.setState({
todos: res.data
})
}
})
.catch(err => console.log(err))
}

deleteTodo = (id) => {

    axios.delete(`/api/todos/${id}`)
      .then(res => {
        if(res.data){
          this.getTodos()
        }
      })
      .catch(err => console.log(err))

}

render() {
let { todos } = this.state;

    return(
      <div>
        <h1>My Todo(s)</h1>
        <Input getTodos={this.getTodos}/>
        <ListTodo todos={todos} deleteTodo={this.deleteTodo}/>
      </div>
    )

}
}

export default Todo;
```
![vim todo.js](images/Project3/Project3-Step2-todo.png)

* Move to the `src` folder
```
cd ..
```
* Make sure that you are in the `src` folder and run:
```
vim App.js
```
* Copy and paste the code below into it:
```
import React from 'react';

import Todo from './components/Todo';
import './App.css';

const App = () => {
return (
<div className="App">
<Todo />
</div>
);
}

export default App;
```
![vim app.js](images/Project3/Project3-Step2-vimapp.png)

* In the `src` directory open the `App.css` then paste the following code:
```
.App {
text-align: center;
font-size: calc(10px + 2vmin);
width: 60%;
margin-left: auto;
margin-right: auto;
}

input {
height: 40px;
width: 50%;
border: none;
border-bottom: 2px #101113 solid;
background: none;
font-size: 1.5rem;
color: #787a80;
}

input:focus {
outline: none;
}

button {
width: 25%;
height: 45px;
border: none;
margin-left: 10px;
font-size: 25px;
background: #101113;
border-radius: 5px;
color: #787a80;
cursor: pointer;
}

button:focus {
outline: none;
}

ul {
list-style: none;
text-align: left;
padding: 15px;
background: #171a1f;
border-radius: 5px;
}

li {
padding: 15px;
font-size: 1.5rem;
margin-bottom: 15px;
background: #282c34;
border-radius: 5px;
overflow-wrap: break-word;
cursor: pointer;
}

@media only screen and (min-width: 300px) {
.App {
width: 80%;
}

input {
width: 100%
}

button {
width: 100%;
margin-top: 15px;
margin-left: 0;
}
}

@media only screen and (min-width: 640px) {
.App {
width: 60%;
}

input {
width: 50%;
}

button {
width: 30%;
margin-left: 10px;
margin-top: 0;
}
}
```
![vim app.css](images/Project3/Project3-Step2-appcss.png)

* In the `src` directory open the `index.css` and paste the code below:
```
body {
margin: 0;
padding: 0;
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
"Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
box-sizing: border-box;
background-color: #282c34;
color: #787a80;
}

code {
font-family: source-code-pro, Menlo, Monaco, Consolas, "Courier New",
monospace;
}
```
![vim index.css](images/Project3/Project3-Step2-indexcss.png)

* Go to the `Todo` directory and run:
```
npm run dev
```
![vim index.css](images/Project3/Project3-Step2-rundev.png)

Assuming no errors when saving all these files, our To-Do app should be ready and fully functional with the functionality discussed earlier: creating a task, deleting a task and viewing all your tasks.

![app finish](images/Project3/Project3-Step2-appfinish.png)

### In this Project #3 you have created a simple To-Do and deployed it to MERN stack. You wrote a frontend application using React.js that communicates with a backend application written using Expressjs. You also created a Mongodb backend for storing tasks in a database.

