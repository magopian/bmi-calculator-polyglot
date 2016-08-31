module BMI exposing (..)

import Html exposing (Html, Attribute, div, input, text, span)
import Html.App as App
import Html.Attributes as Attr
import Html.Attributes exposing (type', value, style)
import Html.Events exposing (on, targetValue)
import Json.Decode as Decode
import Json.Decode exposing ((:=))
import String


main =
    App.beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { weight : Int
    , height : Int
    }


init : Model
init =
    { height = 180, weight = 80 }



-- UPDATE


type Msg
    = SetWeight Int
    | SetHeight Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetHeight h ->
            { model | height = h }

        SetWeight w ->
            { model | weight = w }



-- VIEW


view : Model -> Html Msg
view { height, weight } =
    let
        bmi =
            calcBMI height weight

        ( color, diagnostic ) =
            getColorDiagnostic bmi
    in
        div []
            [ div []
                [ text <| "Height: " ++ toString height ++ "cm"
                , intSlider SetHeight height 100 220
                ]
            , div []
                [ text <| "Weight: " ++ toString weight ++ "kg"
                , intSlider SetWeight weight 30 150
                ]
            , div []
                [ text <| "BMI: " ++ toString (floor bmi) ++ " "
                , span [ style [ ( "color", color ) ] ] [ text diagnostic ]
                , readonlySlider bmi 10 50
                ]
            ]


calcBMI : Int -> Int -> Float
calcBMI height weight =
    let
        heightInM =
            toFloat height / 100
    in
        toFloat weight / heightInM ^ 2


getColorDiagnostic : Float -> ( String, String )
getColorDiagnostic bmi =
    if bmi < 18.5 then
        ( "orange", "underweight" )
    else if bmi < 25 then
        ( "inherit", "normal" )
    else if bmi < 30 then
        ( "orange", "overweight" )
    else
        ( "red", "obese" )


sliderAttrs : number -> number -> number -> List (Attribute Msg)
sliderAttrs val minVal maxVal =
    [ type' "range"
    , value (toString val)
    , Attr.min (toString minVal)
    , Attr.max (toString maxVal)
    ]


intValueDecoder : Decode.Decoder Int
intValueDecoder =
    targetValue
        `Decode.andThen`
            \s ->
                case String.toInt s of
                    Ok i ->
                        Decode.succeed i

                    Err e ->
                        Decode.fail e


intSlider : (Int -> Msg) -> Int -> Int -> Int -> Html Msg
intSlider mkMsg val minVal maxVal =
    input
        (sliderAttrs val minVal maxVal
            ++ [ on "change" (Decode.map mkMsg intValueDecoder) ]
        )
        []


readonlySlider : number -> number -> number -> Html Msg
readonlySlider val minVal maxVal =
    input
        (sliderAttrs val minVal maxVal ++ [ Attr.readonly True ])
        []
