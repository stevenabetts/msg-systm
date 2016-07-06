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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

    UpdateTagInput content ->
      ({ model | tagInput = content }, Cmd.none)

    UpdateSearchQuery content ->
      ({model | searchQuery = content :: model.searchQuery}, Cmd.none)


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
          onInput UpdateTagInput
        ]
        [],
      button [ class "add", onClick UpdateSearchQuery ] [ text "Add" ],
      h2
        []
        [ text (model.phraseInput ++ " " ++ model.pointsInput) ]
    ]

itemFirstLine : Message -> Html Msg
itemFirstLine message =
  div [ class "firstline" ] [
        span [ class "process" ] [ text (toString message.id) ],
        if message.status == True
        then span [ class "active" ] [ text "Delivered" ]
        else span [ class "inactive" ] [ text "Pending" ],
        span [class "select"] [text (toString message.delivered_at)]
  ]
messageItem : Message -> Html Msg
messageItem message = 
  li [] [itemFirstLine message]

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