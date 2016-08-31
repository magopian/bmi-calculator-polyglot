module BMI exposing (..)

import Html exposing (Html, Attribute, div, input, text, span)
import Html.App as App
import Html.Attributes as Attr
import Html.Attributes exposing (type', value, style)
import Html.Events exposing (on, targetValue)
import Json.Decode as Decode
import Json.Decode exposing (Decoder)
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
    | SetBMI Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetHeight h ->
            { model | height = h }

        SetWeight w ->
            { model | weight = w }
            
        SetBMI bmi ->
            { model | weight = calcWeightFromBMI model.height bmi }



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
                , slider SetHeight intValDecoder height 100 220
                ]
            , div []
                [ text <| "Weight: " ++ toString weight ++ "kg"
                , slider SetWeight intValDecoder weight 30 150
                ]
            , div []
                [ text <| "BMI: " ++ toString (floor bmi) ++ " "
                , span [ style [ ( "color", color ) ] ] [ text diagnostic ]
                , slider SetBMI floatValDecoder bmi 10 50
                ]
            ]


cmToM : Int -> Float
cmToM height =
    toFloat height / 100


calcBMI : Int -> Int -> Float
calcBMI height weight =
    toFloat weight / (cmToM height) ^ 2
    
    
calcWeightFromBMI : Int -> Float -> Int
calcWeightFromBMI height bmi =
    bmi / (cmToM height) ^ 2
        |> floor


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


chainResult : Decoder a -> (a -> Result e b) -> Decoder b
chainResult decoder fn =
    decoder `Decode.andThen`
        \v ->
            case fn of
                Ok v' ->
                    Decode.succeed v
                    
                Err e ->
                    Decode.fail e


intValDecoder : Decoder Int
intValDecoder =
    chainResult targetValue String.toInt
    
    
floatValDecoder : Decoder Int
floatValDecoder =
    chainResult targetValue String.toFloat


slider : (a -> Msg) -> Decoder a -> a -> a -> a -> Html Msg
slider mkMsg decoder val minVal maxVal =
    input
        [ type' "range"
        , value (toString val)
        , Attr.min (toString minVal)
        , Attr.max (toString maxVal)
        , on "change" (Decode.map mkMsg decoder)
        ]
        []
