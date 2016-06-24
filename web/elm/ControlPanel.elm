port module ControlPanel exposing (..)

import String exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as Html

--import Task exposing (Task)



--MODEL

type alias Model =
    {
        processes : List Process,
        nameInput : String,
        nextID : Int,
        inputModel: String,
        retryModel: String,
        mpsModel: String,
        workersModel:String
    }
    
type alias Process =
    {
        name : String,
        isActive: Bool,
        mps: Int,
        id: Int,
        isSelected: Bool,
        numWorkers: Int,
        iQueue: String,
        rQueue: String
    }
    
type alias DBProcess =
    {
        name : String,
        isActive: Bool,
        mps: Int,
        id: Int,
        numWorkers: Int,
        iQueue: String,
        rQueue: String
    }
    
type alias DBList =
  List DBProcess

newProcess : String -> Int -> String -> String -> Process
newProcess name id iQueue rQueue=
    {
        name = name,
        isActive = False,
        mps = 0,
        id = id,
        isSelected = False,
        numWorkers = 0,
        iQueue = iQueue,
        rQueue = rQueue
    }
   
convertProcess : DBProcess -> Process
convertProcess dbprocess =
  {
        name = .name dbprocess,
        isActive = .isActive dbprocess,
        mps = .mps dbprocess,
        id = .id dbprocess,
        isSelected = False,
        numWorkers = .numWorkers dbprocess,
        iQueue = .iQueue dbprocess,
        rQueue = .rQueue dbprocess
  }
  
reconvertProcess : Process -> DBProcess
reconvertProcess process =
  {
        name = .name process,
        isActive = .isActive process,
        mps = .mps process,
        id = .id process,
        numWorkers = .numWorkers process,
        iQueue = .iQueue process,
        rQueue = .rQueue process
  }
    
init : (Model, Cmd Msg)
init =
  let
    initialModel =
      { processes =
          [],
          nameInput = "",
          nextID = 0,
          inputModel = "",
          retryModel = "",
          mpsModel = "",
          workersModel = ""
      }
  in
    (initialModel, Cmd.none)

-- UPDATE

type Msg
  = NoOp
  | Select Int
  --| Collapse
  --| Delete Int
  --| UpdateNameInput String
  | UpdateInputModel String
  --| UpdateInputQueue Process String
  --| RequestUpdateInput Process String
  | UpdateRetryModel String
  --| UpdateRetryQueue Process String
  --| Add
  | UpdateMpsModel String
  | UpdateWorkersModel String
  | UpdateInputQueue Process
  | RequestUpdateInput Process
  
  | UpdateRetryQueue Process
  | RequestUpdateRetry Process
  
  | AddRemoveWorkers Process
  | RequestUpdateWorkers Process
  
  | ChangeMps Process
  | RequestChangeMps Process
  
  | Activate Process
  | RequestActivate Process
  
  | SetProcesses DBList


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    
    Select id ->
      let
        updateEntry e =
          if e.id == id then { e | isSelected = (not e.isSelected) } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
    

    {- 
    Delete id ->
      let
        remainingEntries = List.filter (\e -> e.id /= id) model.processes
      in
        ({ model | processes = remainingEntries }, Cmd.none)
        
    UpdateNameModel content ->
        ({ model | nameInput = content }, Cmd.none)
        
      
    Add ->
      let
        entryToAdd =
          newProcess model.nameInput model.nextID model.inputInput model.retryInput
        isInvalid model =
          String.isEmpty model.nameInput
      in
        if isInvalid model
        then (model, Cmd.none)
        else
          ({ model |
              nameInput = "",
              inputInput = "",
              retryInput = "",
              processes = entryToAdd :: model.processes,
              nextID = model.nextID + 1
          }, Cmd.none)
          -}
    UpdateInputModel content ->
        ({ model | inputModel = content }, Cmd.none)
        
    UpdateRetryModel content ->
        ({ model | retryModel = content }, Cmd.none)

    UpdateMpsModel content ->
        ({ model | mpsModel = content }, Cmd.none)

    UpdateWorkersModel content ->
        ({ model | workersModel = content }, Cmd.none)
    
    Activate process ->
      let
        updateEntry e =
          if e.id == process.id then { e | isActive = process.isActive } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
        
    RequestActivate process ->
      (model, processActivationRequests (reconvertProcess process))
    
    UpdateInputQueue process ->
      let
        updateEntry e =
          if e.id == process.id then { e | iQueue = process.iQueue } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
    
    RequestUpdateInput process ->
      (model, updateInputRequests {id = process.id, string = model.inputModel})
    
    UpdateRetryQueue process ->
      let
        updateEntry e =
          if e.id == process.id then { e | rQueue = process.rQueue } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
    
    RequestUpdateRetry process ->
      (model, updateRetryRequests {id = process.id, string = model.retryModel})
    
    AddRemoveWorkers process ->
      let
        updateEntry e =
          if e.id == process.id then { e | numWorkers = process.numWorkers } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
    
    RequestUpdateWorkers process ->
      (model, changeWorkersRequests {id = process.id, value = (toInt model.workersModel |> Result.toMaybe |> Maybe.withDefault 0)})
    
    ChangeMps process ->
      let
        updateEntry e =
          if e.id == process.id then { e | mps = process.mps } else e
      in
        ({ model | processes = List.map updateEntry model.processes }, Cmd.none)
    
    RequestChangeMps process ->
      (model, changeMpsRequests {id = process.id, value = (toInt model.mpsModel |> Result.toMaybe |> Maybe.withDefault 0)})
    
    SetProcesses dblist ->
      let
        entriesToAdd = List.map convertProcess dblist
      in
        ({ model |
              nameInput = "",
              inputModel = "",
              retryModel = "",
              mpsModel = "",
              workersModel = "",
              processes = entriesToAdd,
              nextID = (List.length dblist) + 1
          }, Cmd.none)
        
--VIEW

view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ pageHeader model,
        --entryForm model,
        entryList model.processes,
        pageFooter
        ]
        
pageHeader : Model -> Html Msg
pageHeader model =
    h1 [ ] [ text "Message System Control Panel" ]
    --h1 [] [text ("MpsModel" ++ (toString model.mpsModel)), text ("WorkersModel" ++ (toString model.workersModel))]
    
pageFooter : Html Msg
pageFooter =
  footer
    [ ]
    [ a [ href "https://example.com" ] [ text "Example Link" ] ]

itemFirstLine : Process -> Html Msg
itemFirstLine process =
  div [ class "firstline" ] [
          span [ class "process" ] [ text (process.name ++ (toString process.id)) ],
          if process.isActive == True
          then span [ class "active" ] [ text "Active" ]
          else span [ class "inactive" ] [ text "Inactive" ],
          if process.isActive == True
          then span [ class "bgtoggleoff" ] 
            [ button [ class "toggleoff" ,onClick (RequestActivate process) ] [ ],
                span [ style [("position", "absolute"),("clip", "rect(0px, 0px, 0px, 0px)")] ] [ text "Off"],
                span [ style [("position", "absolute"),("clip", "rect(0px, 0px, 0px, 0px)")] ] [ text "On" ] ]
          else span [ class "bgtoggleon" ] 
            [ button [ class "toggleon" ,onClick (RequestActivate process) ] [ ],
                span [ style [("position", "absolute"),("clip", "rect(0px, 0px, 0px, 0px)")] ] [ text "Off"],
                span [ style [("position", "absolute"),("clip", "rect(0px, 0px, 0px, 0px)")] ] [ text "On" ] ],
          if process.isSelected == True
          then button [ class "select", onClick (Select process.id) ] [ text "Close" ]
          else button [ class "select", onClick (Select process.id) ] [ text "Edit" ]
        ]

itemSecondLine : Process -> Html Msg
itemSecondLine process =
  div [ class "nextline" ] [
          span [ class "workers" ] [ text ("Number of Workers") ],
          --span [ class "numberdisplay" ] [ text (toString process.numWorkers) ],
          span [ class "numberfield" ]
             [  input
                [ type' "number",
                  placeholder (toString process.numWorkers),
                  name "numworkers",
                  autofocus True,
                  onInput (UpdateWorkersModel)--Save value to model, another button to send model info to JS
                ] []
             ],
             button [ class "select", onClick (RequestUpdateWorkers process) ] [ text "Save" ]]
             
itemThirdLine : Process -> Html Msg
itemThirdLine process =
  div [ class "nextline" ] [
          span [ class "workers" ] [ text ("Input Queue") ],
          span [ class "stringfield" ]
             [  input
                [ type' "text",
                  placeholder process.iQueue,
                  name "iqueue",
                  autofocus True,
                  onInput (UpdateInputModel)--save value to model, another button to send model info to JS
                ] []
             ],
             button [ class "select", onClick (RequestUpdateInput process) ] [ text "Save" ]]

itemFourthLine : Process -> Html Msg
itemFourthLine process =
  div [ class "nextline" ] [
          span [ class "workers" ] [ text ("Retry Queue") ],
          span [ class "stringfield" ]
             [  input
                [ type' "text",
                  placeholder process.rQueue,
                  name "iqueue",
                  autofocus True,
                  onInput (UpdateRetryModel)
                ] []
             ],
             button [ class "select", onClick (RequestUpdateRetry process) ] [ text "Save" ]]

itemFifthLine : Process -> Html Msg
itemFifthLine process =
  div [ class "nextline" ] [
          span [ class "workers" ] [ text ("Messages per Second") ],
          --span [ class "numberdisplay" ] [ text (toString process.mps) ],
          span [ class "numberfield" ]
             [  input
                [ type' "number",
                  placeholder (toString process.mps),
                  name "iqueue",
                  autofocus True,
                  onInput (UpdateMpsModel)
                ] []
             ],
             button [ class "select", onClick (RequestChangeMps process) ] [ text "Save" ]]

entryItem : Process -> Html Msg
entryItem  process =
  if process.isSelected == True
  
  then li 
        [ class "big"]
        [ itemFirstLine process,
          itemSecondLine process,
          itemThirdLine process,
          itemFourthLine process,
          itemFifthLine process
        ]
  
  else  li 
        [ class "normal" ]
        [ itemFirstLine process ]


entryList : List Process -> Html Msg
entryList processes =
  let
    entryItems = List.map (entryItem) processes
  in
    ul [ ] entryItems

{-|
entryForm : Model -> Html Msg
entryForm model =
  div []
    [ input
        [ type' "text",
          placeholder "Process Name",
          value model.nameInput,
          name "name",
          autofocus True,
          onInput UpdateNameInput
        ]
        [],
      input
        [ type' "text",
          placeholder "Input Queue",
          value model.inputInput,
          name "iqueue",
          autofocus True,
          onInput UpdateInputInput
        ]
        [],
      input
        [ type' "text",
          placeholder "Retry Queue",
          value model.retryInput,
          name "rqueue",
          autofocus True,
          onInput UpdateRetryInput
        ]
        [],
      button [ class "add", onClick Add ] [ text "Add" ]
    ]
    -}


--MAIN

main = 
  Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }

--PORTS/SUBSCRIPTIONS

--Initial--
port processLists : (DBList -> msg) -> Sub msg


processListsToSet: Sub Msg
processListsToSet =
  processLists SetProcesses
  
--Activation--
port processActivationUpdates: (DBProcess -> msg) -> Sub msg
port processActivationRequests : DBProcess -> Cmd msg

convertActivationUpdates: Sub Process
convertActivationUpdates = 
  processActivationUpdates convertProcess

processesToActivate: Sub Msg
processesToActivate =
  Sub.map Activate convertActivationUpdates

--Change Workers--
port changeWorkersRequests : {id: Int, value: Int} -> Cmd msg
port changeWorkersUpdates: (DBProcess -> msg) -> Sub msg

convertWorkersUpdates: Sub Process
convertWorkersUpdates = 
  changeWorkersUpdates convertProcess

workersToChange: Sub Msg
workersToChange =
  Sub.map AddRemoveWorkers convertWorkersUpdates
  
--Change Input Queue--
port updateInputRequests : {id: Int, string: String} -> Cmd msg
port changeInputUpdates: (DBProcess -> msg) -> Sub msg

convertInputUpdates: Sub Process
convertInputUpdates = 
  changeInputUpdates convertProcess

inputToChange: Sub Msg
inputToChange =
  Sub.map UpdateInputQueue convertInputUpdates

--Change Retry Queue--
port updateRetryRequests : {id: Int, string: String} -> Cmd msg
port changeRetryUpdates: (DBProcess -> msg) -> Sub msg

convertRetryUpdates: Sub Process
convertRetryUpdates = 
  changeRetryUpdates convertProcess

retryToChange: Sub Msg
retryToChange =
  Sub.map UpdateRetryQueue convertRetryUpdates

--Change MpS--
port changeMpsRequests : {id: Int, value: Int} -> Cmd msg
port changeMpsUpdates: (DBProcess -> msg) -> Sub msg

convertMpsUpdates: Sub Process
convertMpsUpdates = 
  changeMpsUpdates convertProcess

mpsToChange: Sub Msg
mpsToChange =
  Sub.map ChangeMps convertMpsUpdates







subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.batch [processListsToSet, processesToActivate]


