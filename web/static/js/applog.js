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
var elmDiv2 = document.getElementById('elm-log'),
   //initialState = {processLists: [],
                    //processUpdates: {name:"", isActive:false, mps:0, id:0, numWorkers:0, iQueue:"", rQueue:"", dts:0}}, 
                    elmApp2 = Elm.MessageLog.embed(elmDiv2);

let logchannel = socket.channel("messages:lobby", {})
logchannel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

//Querying Messages
elmApp2.ports.searchRequests.subscribe(query => {
  logchannel.push("request_searchmessage", query)
    .receive("error", payload => console.log(payload.message))
})
logchannel.on("results_obtained", results => elmApp2.ports.searchUpdates.send(results))