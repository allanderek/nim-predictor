module Return exposing
    ( andThen
    , noCmd
    , withCmd
    , withModel
    )


noCmd : model -> ( model, Cmd msg )
noCmd model =
    ( model, Cmd.none )


withCmd : Cmd msg -> model -> ( model, Cmd msg )
withCmd command model =
    ( model, command )


withModel : model -> Cmd msg -> ( model, Cmd msg )
withModel model command =
    ( model, command )


andThen : (model -> ( model, Cmd msg )) -> ( model, Cmd msg ) -> ( model, Cmd msg )
andThen update ( model, command ) =
    let
        ( newModel, extraCommand ) =
            update model
    in
    ( newModel
    , Cmd.batch [ extraCommand, command ]
    )
