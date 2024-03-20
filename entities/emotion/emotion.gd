tool
class_name Emotion extends Resource

# Cannot be reordered at least for now because enums as dictionary keys inside custom resources are just ints -_-
enum EmotionKey {
    CONFUSION,
    ANXIETY,
    DOUBT,
    EXCITED,
    PETRIFIED
}

export(EmotionKey) var emotionKey
export(String) var name
export(String) var description
# texture?