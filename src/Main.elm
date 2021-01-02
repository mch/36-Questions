module Main exposing (..)

import Browser
import Dict
import Html exposing (Html, pre, text)
import Html.Attributes
import Html.Events



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Question
    = None
    | Closeness Int
    | Smalltalk Int


type alias Model =
    { question : Question
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { question = None }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SelectedCloseness
    | SelectedSmallTalk
    | NextQuestion
    | SelectedQuestion String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectedCloseness ->
            ( { model | question = Closeness 0 }, Cmd.none )

        SelectedSmallTalk ->
            ( { model | question = Smalltalk 0 }, Cmd.none )

        NextQuestion ->
            ( { model | question = nextQuestion model.question }, Cmd.none )

        SelectedQuestion q ->
            ( { model | question = selectQuestion model.question q }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


nextQuestion question =
    case question of
        None ->
            None

        Closeness q ->
            if q < (Dict.size closenessQuestions - 1) then
                Closeness (q + 1)

            else
                Closeness 0

        Smalltalk q ->
            if q < Dict.size smalltalkQuestions then
                Smalltalk (q + 1)

            else
                Smalltalk 0


selectQuestion currentQuestion q =
    case currentQuestion of
        None ->
            None

        Closeness _ ->
            Closeness (String.toInt q |> Maybe.withDefault 0)

        Smalltalk _ ->
            Smalltalk (String.toInt q |> Maybe.withDefault 0)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model.question of
        None ->
            viewSelectionButtons

        Closeness q ->
            viewQuestion q closenessQuestions "Closeness"

        Smalltalk q ->
            viewQuestion q smalltalkQuestions "Small talk"


viewSelectionButtons =
    Html.div
        [ Html.Attributes.class "buttons"
        ]
        [ Html.button
            [ Html.Attributes.class "button"
            , Html.Events.onClick SelectedSmallTalk
            ]
            [ Html.text "Small Talk" ]
        , Html.button
            [ Html.Attributes.class "button"
            , Html.Events.onClick SelectedCloseness
            ]
            [ Html.text "Closeness" ]
        ]


viewQuestion q questions qtype =
    Html.div []
        [ Html.div
            [ Html.Attributes.class "question-number" ]
            [ Html.datalist [ Html.Attributes.id "qtype" ]
                [ Html.option [ Html.Attributes.value "Small talk" ] []
                , Html.option [ Html.Attributes.value "Closeness" ] []
                ]
            , Html.datalist [ Html.Attributes.id "number" ]
                (List.range
                    1
                    36
                    |> List.map (\x -> Html.option [ Html.Attributes.value (String.fromInt x) ] [])
                )
            , viewQuestionType qtype
            , Html.span [] [ text ", " ]
            , viewQuestionNumber q
            ]
        , Html.div
            [ Html.Attributes.class "question-text"
            , Html.Events.onClick NextQuestion
            ]
            [ text (Dict.get q questions |> Maybe.withDefault "") ]
        ]


viewQuestionType qtype =
    Html.select
        [ Html.Events.onInput
            (\x ->
                case x of
                    "Smalltalk" ->
                        SelectedSmallTalk

                    "Closeness" ->
                        SelectedCloseness

                    _ ->
                        NoOp
            )
        ]
        [ Html.option
            [ Html.Attributes.value "Smalltalk"
            , Html.Attributes.selected (qtype == "Small talk")
            ]
            [ text "Small talk" ]
        , Html.option
            [ Html.Attributes.value "Closeness"
            , Html.Attributes.selected (qtype == "Closeness")
            ]
            [ text "Closeness" ]
        ]


viewQuestionNumber q =
    Html.select
        [ Html.Events.onInput SelectedQuestion
        ]
        (List.range
            1
            36
            |> List.map
                (\x ->
                    Html.option
                        [ Html.Attributes.value (String.fromInt (x - 1))
                        , Html.Attributes.selected (q == (x - 1))
                        ]
                        [ text ("question " ++ String.fromInt x) ]
                )
        )



-- DATA
-- The small talk questions have been modified to be less California / UCSC specific.


smalltalkQuestions =
    Dict.fromList
        (List.indexedMap Tuple.pair
            [ -- Set 1
              "When was the last time you walked for more than an hour? Describe where you went and what you saw."
            , "What was the best gift you ever received and why?"
            , "If you had to move away from where you live now, where would you go, and what would you miss the most about where you live now?"
            , "How did you celebrate last Halloween?"
            , "Do you read a newspaper often and which do you prefer? Why?"
            , "What is a good number of people to have in a student household and why?"
            , "If you could invent a new flavor ofice cream, what would it be?"
            , "What is the best restaurant you've been to in the last month that your partner hasn't been to? Tell your partner about it."
            , "Describe the last pet you owned."
            , "What is your favorite holiday? Why?"
            , "Tell your partner the funniest thing that ever happened to you when you were with a small child."
            , "What gifts did you receive on your last birthday?"
            , -- Set 2
              "Describe the last time you went to the zoo."
            , "Tell the names and ages of your family members, in-clude grandparents, aunts and uncles, and where they were born (to the extent you know this information)."
            , "One of you say a  word, the next say a  word that starts with the last letter of the word just said. Do this until you have said 50 words. Any words will do-you aren't making a sentence."
            , "Do you like to get up early or stay up late? Is there anything funny that has resulted from this?"
            , "Where are you from? Name all of the places you've lived."
            , "What is your favorite thing about this place so far? Why?"
            , "What did you do this summer?"
            , "What gifts did you receive last Christmas/Hanukkah?"
            , "Who is your favorite actor of your own gender? Describe a favorite scene in which this person has acted."
            , "What was your impression of this place the first time you ever came here?"
            , "What is the best TV show you've seen in the last month that your partner hasn't seen? Tell your partner about it."
            , "What is your favorite holiday? Why?"
            , -- Set 3
              "Where did you go to high school? What was your high school like?"
            , "What is the best book you've read in the last three months that your partner hasn't read? Tell your partner about it."
            , "What foreign country would you most like to visit? What attracts you to this place?"
            , "Do you prefer digital watches and clocks or the kind with hands? Why?"
            , "Describe your mother's best friend."
            , "What are the advantages and disadvantages of artificial Christmas trees?"
            , "How often do you get your hair cut? Where do you go? Have you ever had a really bad haircut experience?"
            , "Did you have a class pet when you were in elementary school? Do you remember the pet's name?"
            , "Do you think left-handed people are more creative than right-handed people?"
            , "What is the last concert you saw? How many of that band's albums do you own? Had you seen them before? Where?"
            , "Do you subscribe to any magazines? Which ones? What have you subscribed to in the past?"
            , "Were you ever in a school play? What was your role? What was the plot of the play? Did anything funny ever happen when you were on stage?"
            ]
        )


closenessQuestions =
    Dict.fromList
        (List.indexedMap Tuple.pair
            [ -- Set 1
              "Given the choice of anyone in the world, whom would you want as a dinner guest?"
            , "Would you like to be famous? In what way?"
            , "Before making a telephone call, do you ever rehearse what you are going to say? Why?"
            , "What would constitute a \"perfect\" day for you?"
            , "When did you last sing to yourself? To someone else?"
            , "If you were able to live to the age of 90 and retain either the mind or body of a 30-year-old for the last 60 years of your life, which would you want?"
            , "Do you have a secret hunch about how you will die?"
            , "Name three things you and your partner appear to have in common."
            , "For what in your life do you feel most grateful?"
            , "If you could change anything about the way you were raised, what would it be?"
            , "Take 4 minutes and tell your partner your life story in as much detail as possible."
            , "If you could wake up tomorrow having gained anyone quality or ability, what would it be?"
            , -- Set 2
              "If a crystal ball could tell you the truth about yourself, your life, the future, or anything else, what would you want to know?"
            , "Is there something that you've dreamed of doing for a long time? Why haven't you done it?"
            , "What is the greatest accomplishment of your life?"
            , "What do you value most in a friendship?"
            , "What is your most treasured memory?"
            , "What is your most terrible memory?"
            , "If you knew that in one year you would die suddenly, would you change anything about the way you are now living? Why?"
            , "What does friendship mean to you?"
            , "What roles do love and affection play in your life?"
            , "Alternate sharing something you consider a  positive characteristic of your partner. Share a total of 5 items."
            , "How close and warm is your family? Do you feel your childhood was happier than most other people's?"
            , "How do you feel about your relationship with your mother?"
            , -- Set 3
              "Make 3 true \"we\" statements each. For instance \" are both in this room feeling ... \""
            , "Complete this sentence: \"I wish I had someone with whom I could share ... \""
            , "If you were going to become a close friend with your partner, please share what would be important for him or her to know."
            , "Tell your partner what you like about them; be very honest this time saying things that you might not say to someone you've just met."
            , "Share with your partner an embarrassing moment in your life."
            , "When did you last cry in front of another person? By yourself?"
            , "Tell your partner something that you like about them already."
            , "What, if anything, is too serious to be joked about?"
            , "If you were to die this evening with no opportunity to communicate with anyone, what would you most regret not having told someone? Why haven't you told them yet?"
            , "Your house, containing everything you own, catches fire. After saving your loved ones and pets, you have time to safely make a final dash to save anyone item. What would it be? Why?"
            , "Of all the people in your family, whose death would you find most disturbing? Why?"
            , "Share a personal problem and ask your partner's advice on how he or she might handle it. Also, ask your partner to reflect back to you how you seem to be feeling about the problem you have chosen."
            ]
        )
