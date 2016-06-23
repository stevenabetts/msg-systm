// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
var elmDiv = document.getElementById('elm-main'),
   //initialState = {processLists: [],
                    //processUpdates: {name:"", isActive:false, mps:0, id:0, numWorkers:0, iQueue:"", rQueue:"", dts:0}}, 
                    elmApp = Elm.ControlPanel.fullscreen();
  
let channel = socket.channel("processes:planner", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


channel.on('set_processes', data => {
  console.log('got processes', data.processes)
  elmApp.ports.processLists.send(data.processes)
})

//Process Activation
elmApp.ports.processActivationRequests.subscribe(process => {
  channel.push("request_activateprocess", process)
    .receive("error", payload => console.log(payload.message))
})

channel.on("process_updated", process => elmApp.ports.processActivationUpdates.send(process))

//Changing Workers
elmApp.ports.changeWorkersRequests.subscribe(process => {
  channel.push("request_changeworkers", process)
    .receive("error", payload => console.log(payload.message))
})

channel.on("workers_updated", process => elmApp.ports.changeWorkersUpdates.send(process))

//Changing MPS
elmApp.ports.changeMpsRequests.subscribe(process => {
  channel.push("request_changemps", process)
    .receive("error", payload => console.log(payload.message))
})

channel.on("mps_updated", process => elmApp.ports.changeMpsUpdates.send(process))

//Updating Input Queue
elmApp.ports.updateInputRequests.subscribe(process => {
  channel.push("request_updateinput", process)
    .receive("error", payload => console.log(payload.message))
})

channel.on("input_updated", process => elmApp.ports.changeInputUpdates.send(process))

//Updating Retry Queue
elmApp.ports.updateRetryRequests.subscribe(process => {
  channel.push("request_updateretry", process)
    .receive("error", payload => console.log(payload.message))
})

channel.on("retry_updated", process => elmApp.ports.changeRetryUpdates.send(process))