import '../models/practice_models.dart';

class PracticeLibrary {
  static const moods = ['settled', 'open', 'sleepy', 'unchanged'];
  static const prompts = [
    'Where did you find a little more space?',
    'What did you notice without needing to change it?',
    'What can remain unfinished for now?',
    'Which small detail would you like to keep?'
  ];
  static const patterns = <BreathPattern>[
    BreathPattern(
        id: 'four-columns',
        name: 'Four columns',
        teaching:
            'Four even phases: inhale, pause, exhale, pause. Let the columns guide your attention. Keep breathing comfortable; skip holds or stop whenever you need.',
        rounds: 4,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Pause full', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4),
          BreathPhase(label: 'Pause empty', seconds: 4)
        ]),
    BreathPattern(
        id: 'open-margin',
        name: 'Open margin',
        teaching:
            'Three counts in, four out, without pauses. Use an easy breath and let go of counting if it creates effort.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
    BreathPattern(
        id: 'even-lines',
        name: 'Even lines',
        teaching:
            'An even four-count breath, with no holds. The count is optional; return to ordinary breathing whenever you prefer.',
        rounds: 5,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4)
        ])
  ];
  static const poses = <PoseCard>[
    PoseCard(
        id: "resting-palm",
        name: "Resting palm",
        aka: "CONTACT / HANDS",
        setup:
            "Rest a palm on fabric or a comfortable surface. Notice weight without pressing.",
        breath:
            "Let the breath remain ordinary while attention rests in the hand.",
        ifThis:
            "Turn the hand over or change the surface if contact is uncomfortable."),
    PoseCard(
        id: "small-hinge",
        name: "Small hinge",
        aka: "MOVEMENT / SEAT",
        setup:
            "Sit on a sturdy chair with feet supported. Lean slightly from the hips and return, using your hands on your thighs for support.",
        breath: "Keep breathing through the movement.",
        ifThis:
            "Stay upright and notice foot pressure if leaning is uncomfortable."),
    PoseCard(
        id: "easy-turn",
        name: "Easy turn",
        aka: "MOVEMENT / ROTATION",
        setup:
            "Turn the chest a small amount to one side and back. Leave your hands resting and avoid pulling.",
        breath:
            "Exhale naturally as you return if that feels easy; there is no required timing.",
        ifThis:
            "Make the turn smaller or stay facing forward if you feel strain."),
    PoseCard(
        id: "single-edge",
        name: "A single edge",
        aka: "ATTENTION / SEEING",
        setup:
            "Choose a plain object at a comfortable distance. Follow a short section of its outline with your eyes.",
        breath: "Let breathing stay in the background.",
        ifThis: "Use a sound instead if visual attention is tiring."),
    PoseCard(
        id: "resting-side",
        name: "A supported side",
        aka: "REST / COMFORT",
        setup:
            "Lie on a comfortable side with your head supported. Rest the upper arm on a pillow or along the body.",
        breath: "Notice the ribs moving without trying to deepen the breath.",
        ifThis:
            "Adjust the support or choose a seated position if lying down is uncomfortable.")
  ];
  static const sessions = <PracticeSession>[
    PracticeSession(
        id: "morning-palms",
        title: "The weight of palms",
        subtitle: "Begin with a sensation you can already feel.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "A tactile attention lesson. You are learning to stay curious about a simple sensation without needing to improve it.",
        steps: [
          PracticeStep(
              title: "Place",
              cue:
                  "Rest both palms on your thighs or a comfortable surface. Notice the places where skin or fabric meets support. Let the shoulders stay easy.",
              seconds: 120),
          PracticeStep(
              title: "Compare",
              cue:
                  "Visit one palm, then the other. Notice pressure, warmth or texture. Different sensations do not need to become equal.",
              seconds: 120),
          PracticeStep(
              title: "Release a little",
              cue:
                  "See whether your fingers are doing work they can stop doing. Let them rest without pressing the palms down. Return to ordinary contact when thoughts pull you away.",
              seconds: 120),
          PracticeStep(
              title: "Keep one detail",
              cue:
                  "Choose one detail you noticed. Let that detail be enough to remember. Look around before ending the practice.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "room-around-jaw",
        title: "Room around the jaw",
        subtitle: "Notice small effort without stretching.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease"],
        teaching:
            "This is an observation practice, not a jaw exercise. Keep your mouth in an easy position and avoid forcing movement.",
        steps: [
          PracticeStep(
              title: "Comfort first",
              cue:
                  "Sit supported. Notice the contact of your lips or the space between them. Leave the jaw where it feels comfortable.",
              seconds: 120),
          PracticeStep(
              title: "Name effort",
              cue:
                  "Notice whether the tongue, cheeks or forehead are working. Choose only one area to observe. You do not have to make it relax.",
              seconds: 120),
          PracticeStep(
              title: "Allow less",
              cue:
                  "Let the teeth rest apart if that is comfortable. Keep the tongue easy. If attending to the jaw is uncomfortable, notice your hands instead.",
              seconds: 120),
          PracticeStep(
              title: "Widen attention",
              cue:
                  "Include sounds and the support beneath you. Allow the face to move naturally. Finish by noticing something ordinary in the room.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "small-shoulder-arcs",
        title: "Small shoulder arcs",
        subtitle: "Move gently, then listen to the pause.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        aims: ["stretch", "ease"],
        teaching:
            "Use a stable chair and let your arms hang comfortably. Small, slow movements are the whole lesson.",
        steps: [
          PracticeStep(
              title: "A starting point",
              cue:
                  "Notice the resting position of your shoulders. Let the hands be empty or lightly supported. Keep your breath natural.",
              seconds: 120),
          PracticeStep(
              title: "One small arc",
              cue:
                  "Move one shoulder gently a little forward and back to its resting place. Pause between repetitions. Keep the head comfortable and switch sides when ready.",
              seconds: 120),
          PracticeStep(
              title: "Both together",
              cue:
                  "Try the same small motion with both shoulders, or continue one at a time. Use less range if your neck begins to help. Stop if there is pain.",
              seconds: 120),
          PracticeStep(
              title: "Read the pause",
              cue:
                  "Let movement finish. Notice how stillness feels after the arcs. You may sense a change or simply the support of your seat.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "chair-hinge",
        title: "The chair hinge",
        subtitle: "Explore a small fold from a stable seat.",
        kind: "mobility",
        minutes: 12,
        level: "even",
        aims: ["stretch"],
        teaching:
            "Sit on a sturdy chair with your feet supported. Keep every movement easy to reverse.",
        steps: [
          PracticeStep(
              title: "Settle the base",
              cue:
                  "Place hands on thighs. Notice your sitting bones and the support under your feet. Sit at a comfortable height.",
              seconds: 180),
          PracticeStep(
              title: "Lean a little",
              cue:
                  "Keeping your back comfortable, lean forward a small amount from the hips. Slide the hands slightly along the thighs, then return. Avoid reaching toward the floor.",
              seconds: 180),
          PracticeStep(
              title: "Add a pause",
              cue:
                  "Repeat at your own pace with a rest in the upright position. Notice where the movement begins. Smaller is useful if effort increases.",
              seconds: 180),
          PracticeStep(
              title: "Rest upright",
              cue:
                  "Let your hands stop moving. Notice the shape of your breathing and the contact under your feet. End without testing your maximum range.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "seated-turn",
        title: "A quiet turn",
        subtitle: "Explore an easy rotation, one side at a time.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Keep both feet supported and use a stable seat. There is no need to turn far or pull with your hands.",
        steps: [
          PracticeStep(
              title: "Face forward",
              cue:
                  "Rest your hands on your thighs and soften your gaze. Notice where your chest points and where your weight rests.",
              seconds: 180),
          PracticeStep(
              title: "Toward the right",
              cue:
                  "Turn your chest a small amount right, keeping the head comfortable. Return to centre after each movement. Stop well before any strain.",
              seconds: 180),
          PracticeStep(
              title: "Toward the left",
              cue:
                  "Explore left in the same way. Allow the sides to be different. Let the breath move freely and pause whenever you want.",
              seconds: 180),
          PracticeStep(
              title: "Centre again",
              cue:
                  "Return to a neutral position. Notice the room in front of you and the support beneath you. Let the movement be complete.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "edge-and-centre",
        title: "Edge and centre",
        subtitle: "A visual lesson in choosing attention.",
        kind: "sit",
        minutes: 12,
        level: "even",
        aims: ["sit", "ease"],
        teaching:
            "Choose a plain, comfortable object to look at. If looking is tiring, use the edge of a sound and the quiet after it instead.",
        steps: [
          PracticeStep(
              title: "Choose an object",
              cue:
                  "Look at an everyday object at a comfortable distance. Notice its general shape without naming everything about it.",
              seconds: 180),
          PracticeStep(
              title: "Follow an edge",
              cue:
                  "Let your gaze move slowly along one edge. Pause at a corner or curve. Blinking and looking away are welcome.",
              seconds: 180),
          PracticeStep(
              title: "Return to the whole",
              cue:
                  "Include the whole object and some space around it. Alternate between a detail and the wider view, without rushing.",
              seconds: 180),
          PracticeStep(
              title: "Leave it there",
              cue:
                  "Let the object remain where it is. Notice your hands and feet. Remember one detail, then let attention return to the room.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "patient-breath",
        title: "Patient breath",
        subtitle: "Give breathing room to be ordinary.",
        kind: "breath",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "You do not need a deeper breath. This practice studies the beginning and ending of comfortable, ordinary breathing.",
        steps: [
          PracticeStep(
              title: "Observe",
              cue:
                  "Sit supported and let your breath choose its own size. Find one place where it is easy to feel breathing, or simply notice the body resting.",
              seconds: 120),
          PracticeStep(
              title: "A beginning",
              cue:
                  "Notice when an inhale begins. Follow only as long as it is easy to notice. Let the rest happen without control.",
              seconds: 120),
          PracticeStep(
              title: "An ending",
              cue:
                  "Notice an exhale finishing. Do not hold or lengthen it. When attention wanders, start with the next ordinary breath.",
              seconds: 120),
          PracticeStep(
              title: "Nothing to follow",
              cue:
                  "Stop tracking the breath. Listen to the room and feel the support beneath you. Move gently before finishing.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "unwritten-page",
        title: "The unwritten page",
        subtitle: "A longer practice of leaving thoughts unfinished.",
        kind: "sit",
        minutes: 18,
        level: "rough",
        aims: ["sit", "ease"],
        teaching:
            "Thoughts can be present without becoming assignments. Practice noticing a thought and returning to something tangible.",
        steps: [
          PracticeStep(
              title: "Find a reference",
              cue:
                  "Choose the feeling of your feet, hands or seat. Notice one clear detail about the contact. Keep the body supported.",
              seconds: 270),
          PracticeStep(
              title: "A thought arrives",
              cue:
                  "When a thought appears, name its kind simply: planning, remembering or imagining. You do not need to find a better label.",
              seconds: 270),
          PracticeStep(
              title: "Leave room",
              cue:
                  "Return to your reference point without completing the thought. If it returns, repeat the same small action. This repetition is the practice.",
              seconds: 270),
          PracticeStep(
              title: "Close the page",
              cue:
                  "Release the labels. Notice the whole room and choose one small thing you will do next. There is no need to summarize every thought.",
              seconds: 270)
        ]),
    PracticeSession(
        id: "three-enoughs",
        title: "Three enoughs",
        subtitle: "An evening reflection without a score.",
        kind: "sleep",
        minutes: 12,
        level: "smooth",
        aims: ["sleep", "ease"],
        teaching:
            "Recall ordinary moments, not achievements to prove. If reflection becomes busy, stay with the support beneath you.",
        steps: [
          PracticeStep(
              title: "Enough support",
              cue:
                  "Sit or lie comfortably. Notice one place that is supported. Adjust a pillow, sleeve or foot position if it helps.",
              seconds: 180),
          PracticeStep(
              title: "Enough effort",
              cue:
                  "Recall one ordinary thing you gave effort to today. Describe the action without deciding whether it was good enough.",
              seconds: 180),
          PracticeStep(
              title: "Enough for now",
              cue:
                  "Name one task you can leave until another time. Notice the difference between knowing it exists and working on it now.",
              seconds: 180),
          PracticeStep(
              title: "No more review",
              cue:
                  "Let the day remain incomplete. Return to the feeling of support and allow the exercise to finish.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "resting-layers",
        title: "Resting layers",
        subtitle: "A slow journey from the outside toward quiet.",
        kind: "sleep",
        minutes: 18,
        level: "smooth",
        aims: ["sleep"],
        teaching:
            "Rest in a position you can change easily. Each layer is an invitation to notice, not a request to feel a particular way.",
        steps: [
          PracticeStep(
              title: "The room",
              cue:
                  "Notice temperature, sound and the space around you. Your eyes can stay open or close. Find a comfortable place to rest.",
              seconds: 270),
          PracticeStep(
              title: "The surface",
              cue:
                  "Notice the bed, chair or cushion beneath you. Visit a few points of contact slowly. Adjust any uncomfortable position.",
              seconds: 270),
          PracticeStep(
              title: "The clothing",
              cue:
                  "Notice the feel of clothing or a blanket on the body. Stay with a neutral or comfortable sensation. Skip anything that feels unpleasant.",
              seconds: 270),
          PracticeStep(
              title: "The whole",
              cue:
                  "Allow all the layers to be present together. Stop following instructions and rest in an ordinary way. You may finish or remain here.",
              seconds: 270)
        ])
  ];
}
