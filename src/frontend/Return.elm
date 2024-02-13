module Return exposing
    ( noCmd
    , withCmd
    , cmdWith
    )


noCmd : model -> (model, Cmd msg)
noCmd model =
    ( model, Cmd.none )

withCmd : Cmd msg -> model -> (model, Cmd msg)
withCmd command model =
    ( model, command)

cmdWith : model -> Cmd msg -> (model, Cmd msg)
cmdWith model command =
    ( model, command )
