import '../models/practice_models.dart';

class PracticeLibrary {
  static const moods = ['settled', 'awake', 'tired', 'unchanged'];
  static const prompts = [
    'What helped you switch from one task to another?',
    'Where could a smaller effort be enough?',
    'What will your next small action be?',
    'What can be finished for today, even if incomplete?'
  ];
  static const patterns = <BreathPattern>[
    BreathPattern(
        id: 'four-columns',
        name: 'Four columns',
        teaching:
            'Follow four equal beats: inhale, pause, exhale, pause. The meters rise and settle with your breath. Skip the holds or stop if uncomfortable.',
        rounds: 4,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Pause full', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4),
          BreathPhase(label: 'Pause empty', seconds: 4)
        ]),
    BreathPattern(
        id: 'steady-tempo',
        name: 'Steady tempo',
        teaching:
            'Three counts in and three out, without holds. Keep each breath easy; the count is a guide, not a target.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 3)
        ]),
    BreathPattern(
        id: 'longer-out',
        name: 'Longer out',
        teaching:
            'Three counts in, five out. Use a smaller breath and return to ordinary breathing whenever you prefer.',
        rounds: 5,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 5)
        ])
  ];
  static const poses = <PoseCard>[
    PoseCard(
        id: "pause-marker",
        name: "A pause marker",
        aka: "TRANSITION / START",
        setup:
            "Before changing tasks, place both hands on a comfortable surface and notice their weight.",
        breath: "Take one ordinary breath without making it deeper.",
        ifThis:
            "Keep the hands wherever they already rest if moving them is uncomfortable."),
    PoseCard(
        id: "soft-view",
        name: "Soft view",
        aka: "ATTENTION / SPACE",
        setup:
            "Look away from a close-up task toward a comfortable point in the room. Allow the edges of your view to be present.",
        breath: "Let your breath keep its own pace.",
        ifThis:
            "Close the eyes or use a sound as your anchor if looking farther away is uncomfortable."),
    PoseCard(
        id: "arm-fold",
        name: "Easy arm fold",
        aka: "MOVEMENT / ARMS",
        setup:
            "Sit supported. Bend one elbow a little, then return the hand to the thigh. Switch sides after a few repetitions.",
        breath: "Keep breathing while moving; avoid holding the breath.",
        ifThis:
            "Make the movement smaller or leave the arm resting if it hurts."),
    PoseCard(
        id: "toe-lift",
        name: "Seated toe lift",
        aka: "MOVEMENT / FEET",
        setup:
            "With heels supported, lift the toes a little and lower them. Keep your chair stable and movements slow.",
        breath: "Allow an easy breath between repetitions.",
        ifThis:
            "Keep the whole foot on the floor and notice pressure instead."),
    PoseCard(
        id: "ending-cue",
        name: "An ending cue",
        aka: "REST / BOUNDARIES",
        setup:
            "Name the task you are leaving. Choose one small physical sign of ending, such as closing a notebook.",
        breath: "Notice a natural exhale as the action finishes.",
        ifThis:
            "If the task cannot end yet, name when you will revisit it and take one brief pause.")
  ];
  static const sessions = <PracticeSession>[
    PracticeSession(
        id: "morning-arrival",
        title: "The arrival ritual",
        subtitle: "A clean start before the first task.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "A transition is a skill. Mark the end of arriving before you begin doing.",
        steps: [
          PracticeStep(
              title: "Land",
              cue:
                  "Sit in a comfortable position. Let your bag, phone or unfinished task be put aside. Feel the support under you without changing your posture.",
              seconds: 120),
          PracticeStep(
              title: "Take stock",
              cue:
                  "Name three neutral facts about this moment: where you are, what you can hear, and what your hands are touching. Keep the facts simple.",
              seconds: 120),
          PracticeStep(
              title: "Choose a direction",
              cue:
                  "Ask what the next small action will be. Choose something you can actually begin, such as opening a page or filling a glass. Return to that one action when plans multiply.",
              seconds: 120),
          PracticeStep(
              title: "Begin deliberately",
              cue:
                  "Look around, move your fingers and take one ordinary breath. Let this practice end before starting the next action.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "screen-intermission",
        title: "Screen intermission",
        subtitle: "Shift attention away from the close-up.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Practice changing the scale of attention. You can keep your eyes open, soft or closed, whichever is comfortable.",
        steps: [
          PracticeStep(
              title: "Leave the screen",
              cue:
                  "Turn your gaze away from the screen or close your eyes gently. Notice the weight of your hands. Nothing needs to happen quickly.",
              seconds: 120),
          PracticeStep(
              title: "A wider frame",
              cue:
                  "If your eyes are open, look at a comfortable point farther away. Notice the surrounding space without staring. If closed, notice sounds instead.",
              seconds: 120),
          PracticeStep(
              title: "Unclench effort",
              cue:
                  "Notice your forehead, jaw and fingers. Invite one of them to do a little less. Let breathing stay ordinary.",
              seconds: 120),
          PracticeStep(
              title: "One return",
              cue:
                  "Decide whether to return to the task or take a longer break. Move your gaze slowly and begin only when ready.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "elbow-room",
        title: "Elbow room",
        subtitle: "Small arm movements with room to stop.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        aims: ["stretch", "ease"],
        teaching:
            "Use a stable seat with room around your elbows. Explore an easy range; stop if anything hurts.",
        steps: [
          PracticeStep(
              title: "Set the seat",
              cue:
                  "Rest feet on a firm surface. Place hands lightly on thighs. Let the shoulders settle without pushing them down.",
              seconds: 120),
          PracticeStep(
              title: "Fold and unfold",
              cue:
                  "Bend one elbow to bring the hand a little toward your shoulder, then lower it. Repeat slowly and switch sides. Keep the shoulder relaxed.",
              seconds: 120),
          PracticeStep(
              title: "Hands turn",
              cue:
                  "With elbows resting near your sides, turn the palms upward a little and back toward the thighs. Stay within an effortless range.",
              seconds: 120),
          PracticeStep(
              title: "Notice the return",
              cue:
                  "Rest the arms again. Compare effort rather than distance. Let the next few breaths happen without adding movement.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "seated-steps",
        title: "Seated steps",
        subtitle: "Wake up the feet at a patient pace.",
        kind: "mobility",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Sit on a stable chair. Both feet begin supported. Small movements are enough; leave out any that are uncomfortable.",
        steps: [
          PracticeStep(
              title: "Footprints",
              cue:
                  "Notice the front and back of each foot against the floor. Keep the legs relaxed and the chair steady.",
              seconds: 180),
          PracticeStep(
              title: "Heel then toe",
              cue:
                  "Keeping toes down, lift one heel slightly and lower it. Then keep the heel down and lift the toes a little. Alternate slowly.",
              seconds: 180),
          PracticeStep(
              title: "Change the tempo",
              cue:
                  "Try one gentle heel lift per ordinary breath. Switch feet after a few repetitions. Stop counting whenever it becomes distracting.",
              seconds: 180),
          PracticeStep(
              title: "Still feet",
              cue:
                  "Let both feet settle. Notice warmth, contact or no change at all. End by choosing a comfortable position.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "side-space",
        title: "Side space",
        subtitle: "A chair-based stretch with pauses.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        aims: ["stretch"],
        teaching:
            "Use a comfortable chair without wheels. Stay upright enough to breathe easily and keep both feet supported.",
        steps: [
          PracticeStep(
              title: "Length without effort",
              cue:
                  "Rest hands on thighs. Notice the distance between shoulders and hips. Sit comfortably rather than trying to become taller.",
              seconds: 180),
          PracticeStep(
              title: "Right arm arc",
              cue:
                  "Lift the right hand only to a comfortable height, then return it to your thigh. Keep the trunk quiet. Repeat slowly with pauses.",
              seconds: 180),
          PracticeStep(
              title: "Left arm arc",
              cue:
                  "Explore the same movement with the left arm. Let this side choose its own range. Lower the arm if the neck begins to work.",
              seconds: 180),
          PracticeStep(
              title: "Both sides rest",
              cue:
                  "Rest both hands. Notice space around your ribs and shoulders. Keep ordinary breathing and finish without a final stretch.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "single-channel",
        title: "Single channel",
        subtitle: "Choose one thing to come back to.",
        kind: "sit",
        minutes: 12,
        level: "even",
        aims: ["sit", "ease"],
        teaching:
            "The lesson is selecting and returning. Losing the thread is an opportunity to repeat the skill.",
        steps: [
          PracticeStep(
              title: "Select",
              cue:
                  "Choose a simple anchor: the feeling of your hands, a steady sound, or one object in view. Pick only one for now.",
              seconds: 180),
          PracticeStep(
              title: "Stay briefly",
              cue:
                  "Attend to one quality of the anchor. A hand might feel warm; an object might have a curved edge. Let other details wait.",
              seconds: 180),
          PracticeStep(
              title: "Return kindly",
              cue:
                  "When you notice another thought, silently say next time and return. You do not need to suppress thoughts or finish them.",
              seconds: 180),
          PracticeStep(
              title: "Release the channel",
              cue:
                  "Let attention widen to the whole room. Name one thing that made returning easier. Take that idea into the next task.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "gentle-interval",
        title: "Gentle interval",
        subtitle: "An even breath without holds.",
        kind: "breath",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Counts are a loose guide to attention. Use a smaller breath or stop counting whenever it feels more comfortable.",
        steps: [
          PracticeStep(
              title: "Find ordinary",
              cue:
                  "Sit supported. Notice breathing without adjusting it. Let your shoulders and hands find somewhere easy to rest.",
              seconds: 120),
          PracticeStep(
              title: "Three and three",
              cue:
                  "If comfortable, count three on an inhale and three on an exhale. Do not make the breath larger to fit the count. Skip counting if it causes effort.",
              seconds: 120),
          PracticeStep(
              title: "Notice the gaps",
              cue:
                  "Release the count. Notice how one ordinary breath gives way to another, without adding a pause or holding it.",
              seconds: 120),
          PracticeStep(
              title: "Back to the room",
              cue:
                  "Listen for one nearby sound. Let the breath stay in the background. Move your fingers before returning to the day.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "between-tasks",
        title: "Between two tasks",
        subtitle: "An extended practice of letting one thing end.",
        kind: "sit",
        minutes: 18,
        level: "rough",
        aims: ["sit", "ease"],
        teaching:
            "Use this pause when one activity keeps following you into another. You are practicing a transition, not solving the whole day.",
        steps: [
          PracticeStep(
              title: "Name the ending",
              cue:
                  "Sit comfortably. Name the activity you just left in a few words. Notice the physical traces: busy hands, a fixed gaze or an unsettled seat.",
              seconds: 270),
          PracticeStep(
              title: "Separate the pieces",
              cue:
                  "Notice a thought, then a bodily sensation, then a sound. They can be present together without needing the same response.",
              seconds: 270),
          PracticeStep(
              title: "Make a little room",
              cue:
                  "Choose one useful detail from the previous task. Let the rest wait. If thoughts return, come back to your hands or the support of the chair.",
              seconds: 270),
          PracticeStep(
              title: "Name the beginning",
              cue:
                  "Choose the first small action of the next task. Look around and give yourself permission to begin slowly.",
              seconds: 270)
        ]),
    PracticeSession(
        id: "closing-shift",
        title: "Closing shift",
        subtitle: "A quiet boundary at the end of doing.",
        kind: "sleep",
        minutes: 12,
        level: "smooth",
        aims: ["sleep", "ease"],
        teaching:
            "This lesson helps you mark an ending. Nothing here requires finishing every task or feeling completely calm.",
        steps: [
          PracticeStep(
              title: "Step out of work",
              cue:
                  "Rest in a supported position. Let the hands be empty if possible. Notice that the next few minutes have no task to complete.",
              seconds: 180),
          PracticeStep(
              title: "Acknowledge effort",
              cue:
                  "Recall one thing you gave effort to today. Describe the action without scoring the result. Let that be a complete sentence.",
              seconds: 180),
          PracticeStep(
              title: "Park the next step",
              cue:
                  "If an unfinished task appears, choose when you might return to it. Then let attention settle on the surface supporting you.",
              seconds: 180),
          PracticeStep(
              title: "Evening permission",
              cue:
                  "Notice one ordinary comfort: a soft sleeve, a quiet sound or a supported foot. Release the exercise and stay as long as you like.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "quiet-playback",
        title: "Quiet playback",
        subtitle: "A slower review of one ordinary moment.",
        kind: "sleep",
        minutes: 18,
        level: "smooth",
        aims: ["sleep"],
        teaching:
            "Choose an uncomplicated moment, not one you need to solve. You can switch to noticing the room at any time.",
        steps: [
          PracticeStep(
              title: "Get comfortable",
              cue:
                  "Sit or lie in a position you can adjust easily. Notice the support beneath you and let the breath keep its own rhythm.",
              seconds: 270),
          PracticeStep(
              title: "Choose a moment",
              cue:
                  "Recall a simple moment from today: making a drink, walking through a doorway or seeing a familiar object. Keep it small.",
              seconds: 270),
          PracticeStep(
              title: "Replay one detail",
              cue:
                  "Notice a colour, texture or sound from that moment. Let the detail fade whenever it wants to. There is no need to make the memory vivid.",
              seconds: 270),
          PracticeStep(
              title: "End the playback",
              cue:
                  "Return to the room around you. Notice your hands and the support beneath you. No further review is needed tonight.",
              seconds: 270)
        ])
  ];
}
