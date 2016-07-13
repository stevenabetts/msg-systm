port module MessageLog exposing (..)

import String exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as Html

--MODEL

type alias Model =
    {
        messages : List Message,
        searchQuery: List String,
        tagInput: String,
        filterByDate: Bool,
        filterByStatus: Bool
    }

type alias Message =
    {
        id: Int,
        status: Bool,
        deliveredAt: String
    }

type alias DBMessage = 
    {
        id: Int,
        status: Bool,
        deliveredAt: String,
        tags: {}
    }

type alias DBMessageList =
  List DBMessage

convertMessage : DBMessage -> Message
convertMessage dbmessage = 
  {
    id = .id dbmessage,
    status = .status dbmessage,
    deliveredAt = .deliveredAt dbmessage
  }

init : (Model, Cmd Msg)
init =
  let
    initialModel =
      { messages =
          [],
          searchQuery = [],
          tagInput = "",
          filterByDate = False,
          filterByStatus = False
      }
  in
    (initialModel, Cmd.none)

-- UPDATE

type Msg
    = NoOp
    | UpdateTagInput String
    | UpdateSearchQuery String
    | SearchMessages
    | DisplayMessages DBMessageList
    | ClearSearchQuery

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

    UpdateTagInput content ->
      ({ model | tagInput = content }, Cmd.none)

    UpdateSearchQuery content ->
      ({model | searchQuery = content :: model.searchQuery}, Cmd.none)

    SearchMessages ->
      (model, searchRequests model.searchQuery)
    
    DisplayMessages dbmessagelist ->
      let
        messagesToShow = List.map convertMessage dbmessagelist
      in
        ({model | messages = messagesToShow}, Cmd.none)

    ClearSearchQuery ->
      ({model | searchQuery = []}, Cmd.none)
--VIEW

view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ pageHeader model,
        filterForm model,
        messageList model.messages
        ]

pageHeader : Model -> Html Msg
pageHeader model =
    h1 [ ] [ text "Message Log" ]

filterForm : Model -> Html Msg
filterForm model =
  div []
    [ input
        [ type' "text",
          placeholder "Add Tag",
          name "tag",
          autofocus True,
          onInput (UpdateTagInput)
        ]
        [],
      button [ class "add", onClick (UpdateSearchQuery model.tagInput) ] [ text "Add" ],
      h2
        []
        [ text ("Current Query: " ++ toString model.searchQuery) ],
      button [ class "add", onClick (ClearSearchQuery) ] [ text "Clear" ],
      button [ class "add", onClick (SearchMessages) ] [ text "Search" ]
    ]

itemFirstLine : Message -> Html Msg
itemFirstLine message =
  div [ class "firstline" ] [
        span [ class "process" ] [ text (toString message.id) ],
        if message.status == True
        then span [ class "active" ] [ text "Delivered" ]
        else span [ class "inactive" ] [ text "Pending" ],
        span [class "numberfield"] [text (toString message.deliveredAt)]
  ]
messageItem : Message -> Html Msg
messageItem message = 
  li [ class "normal"] [itemFirstLine message]

messageList : List Message -> Html Msg
messageList messages =
  let
    messageItems = List.map (messageItem) messages
  in
    ul [ ] messageItems

--MAIN

main = 
  Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }


--PORTS/SUBSCRIPTIONS

port searchRequests: List String -> Cmd msg
port searchUpdates: (DBMessageList -> msg) -> Sub msg

subscriptions: Model -> Sub Msg
subscriptions model =
  searchUpdates DisplayMessages
