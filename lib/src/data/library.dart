import '../models/practice_models.dart';

class PracticeLibrary {
  static const moods = ['grounded', 'clear', 'tired', 'unchanged'];
  static const prompts = [
    'What did you notice at a point of contact?',
    'Where did a smaller movement feel easier?',
    'Which sound brought you back to the present?',
    'What can you leave until tomorrow?'
  ];
  static const patterns = <BreathPattern>[
    BreathPattern(
        id: 'four-columns',
        name: 'Four columns',
        teaching:
            'Inhale, pause, exhale, pause: four equal phases. Follow the columns without forcing the breath. Skip pauses or stop if uncomfortable.',
        rounds: 4,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Pause full', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4),
          BreathPhase(label: 'Pause empty', seconds: 4)
        ]),
    BreathPattern(
        id: 'soft-current',
        name: 'Soft current',
        teaching:
            'A gentle three-count inhale and four-count exhale. No pauses; keep the breath small and comfortable.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
    BreathPattern(
        id: 'even-leaves',
        name: 'Even leaves',
        teaching:
            'An even rhythm with no holds. Let the count guide attention, not the size of your breath.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 3)
        ])
  ];
  static const poses = <PoseCard>[
    PoseCard(
        id: "supported-seat",
        name: "Supported seat",
        aka: "FOUNDATION / CONTACT",
        setup:
            "Use a stable chair with feet on the floor or a firm support. Rest your hands on your thighs.",
        breath:
            "Let breathing stay ordinary while you notice the seat beneath you.",
        ifThis:
            "Add support behind the back or change position if sitting becomes uncomfortable."),
    PoseCard(
        id: "wall-reach",
        name: "Wall reach",
        aka: "MOVEMENT / SHOULDERS",
        setup:
            "Stand near a wall. Slide one hand upward only within a comfortable range, then lower it. Repeat on the other side.",
        breath:
            "Breathe freely rather than holding the breath as the arm rises.",
        ifThis: "Lower the reach or stay seated. Stop if movement hurts."),
    PoseCard(
        id: "heel-rock",
        name: "Heel rock",
        aka: "MOVEMENT / FEET",
        setup:
            "Hold a sturdy chair. Gently shift weight from heels toward the front of the feet without lifting them.",
        breath: "Allow one easy breath between shifts.",
        ifThis:
            "Keep the movement tiny, or explore foot pressure while seated instead."),
    PoseCard(
        id: "side-rest",
        name: "Side rest",
        aka: "REST / SUPPORT",
        setup:
            "Lie on either side with a pillow under your head. Bend the knees comfortably and support the upper arm.",
        breath: "Feel the ribs move without trying to change them.",
        ifThis:
            "Adjust the pillow or choose a supported sitting position if lying down is uncomfortable."),
    PoseCard(
        id: "open-palm",
        name: "Open palm",
        aka: "ATTENTION / TOUCH",
        setup:
            "Rest one palm upward on your thigh. Notice air, warmth and contact without stretching the fingers.",
        breath: "Use the breath as a gentle reminder to release excess effort.",
        ifThis:
            "Turn the palm downward or place a soft cloth underneath if more comfortable.")
  ];
  static const sessions = <PracticeSession>[
    PracticeSession(
        id: "morning-ground",
        title: "Contact map",
        subtitle: "Learn where your body meets support.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Attention becomes easier when it has a physical reference. Explore contact before trying to change anything.",
        steps: [
          PracticeStep(
              title: "Find support",
              cue:
                  "Sit with both feet resting on the floor. Notice the chair supporting your weight. Let the hands rest wherever they are comfortable.",
              seconds: 120),
          PracticeStep(
              title: "Three points",
              cue:
                  "Move attention between your left foot, right foot and seat. Spend several ordinary breaths at each point. You do not need equal sensations.",
              seconds: 120),
          PracticeStep(
              title: "Widen the map",
              cue:
                  "Include the back, hands and sounds around you. If attention wanders, return to one foot, then widen again.",
              seconds: 120),
          PracticeStep(
              title: "Carry one detail",
              cue:
                  "Choose a small sensation to remember: warmth, pressure or texture. Open your eyes if closed and let your gaze settle before standing.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "shoulder-compass",
        title: "Shoulder compass",
        subtitle: "Discover a smaller, easier range.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        aims: ["stretch", "ease"],
        teaching:
            "A movement lesson for a seated break. Use a stable chair and keep every movement small enough to feel easy.",
        steps: [
          PracticeStep(
              title: "Neutral first",
              cue:
                  "Sit comfortably, feet supported. Let the arms hang. Notice the resting height of each shoulder without correcting it.",
              seconds: 120),
          PracticeStep(
              title: "Up and down",
              cue:
                  "Slowly lift the shoulders a little, then release. Rest for one breath between repetitions. Stop before strain.",
              seconds: 120),
          PracticeStep(
              title: "Forward and back",
              cue:
                  "Slide the shoulders gently forward, then back toward their resting place. Keep the ribs quiet. Make the movement smaller if the neck joins in.",
              seconds: 120),
          PracticeStep(
              title: "Compare and rest",
              cue:
                  "Let the arms settle. Compare the feeling with the beginning. A small difference is enough; no difference is also useful information.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "standing-roots",
        title: "Standing roots",
        subtitle: "A supported lesson in steady balance.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Stand near a wall or sturdy chair. Keep a hand on support throughout if that feels better. There is no single correct amount of sway.",
        steps: [
          PracticeStep(
              title: "Base",
              cue:
                  "Place feet comfortably apart and soften the knees. Touch the chair. Feel the heels and the front of both feet.",
              seconds: 180),
          PracticeStep(
              title: "Side to side",
              cue:
                  "Shift a little weight toward one foot, then the other, without lifting either. Keep looking at one steady point. Pause often.",
              seconds: 180),
          PracticeStep(
              title: "Reach and return",
              cue:
                  "With one hand supported, float the other hand forward to a comfortable height. Bring it back. Change sides halfway through.",
              seconds: 180),
          PracticeStep(
              title: "Settle",
              cue:
                  "Stand evenly again or sit down. Notice how the floor feels. Take a few natural breaths before leaving the practice.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "rib-window",
        title: "Rib window",
        subtitle: "Make room for gentle side movement.",
        kind: "mobility",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Use a chair with both feet supported. Explore one side at a time without pulling on your neck.",
        steps: [
          PracticeStep(
              title: "Observe",
              cue:
                  "Rest palms on the side ribs. Breathe normally and notice any movement under your hands. You do not need a deeper breath.",
              seconds: 180),
          PracticeStep(
              title: "Right side",
              cue:
                  "Let the right arm rest. Slide the right hand a short way down beside the chair and return upright. Keep both sitting bones supported.",
              seconds: 180),
          PracticeStep(
              title: "Left side",
              cue:
                  "Repeat on the left, at your own pace. Leave a full breath between movements. The sides do not need to match.",
              seconds: 180),
          PracticeStep(
              title: "Window open",
              cue:
                  "Return both hands to the ribs. Notice whether the ordinary breath feels different. Finish with stillness rather than a larger stretch.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "hand-study",
        title: "A study of hands",
        subtitle: "Release effort from a familiar place.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "stretch"],
        teaching:
            "This seated lesson explores touch and gentle finger movement. Use no force and rest whenever you prefer.",
        steps: [
          PracticeStep(
              title: "Resting hands",
              cue:
                  "Place the hands on your thighs. Notice which parts touch and which parts hover. Let the elbows feel heavy.",
              seconds: 120),
          PracticeStep(
              title: "Open and soften",
              cue:
                  "Open the fingers gently, then let them curl naturally. Avoid making a tight fist. Repeat slowly with pauses.",
              seconds: 120),
          PracticeStep(
              title: "Thumb trail",
              cue:
                  "Touch the thumb lightly to each fingertip, one hand at a time. Look at the movement or feel it with your eyes soft.",
              seconds: 120),
          PracticeStep(
              title: "Afterimage",
              cue:
                  "Rest both hands again. Notice temperature or tingling without needing either. Carry softer hands into your next task.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "sound-distance",
        title: "Near, far, here",
        subtitle: "Learn to shift the lens of attention.",
        kind: "sit",
        minutes: 12,
        level: "even",
        aims: ["sit", "ease"],
        teaching:
            "Sounds can be objects of attention without becoming a problem to solve. Use ordinary sounds already around you.",
        steps: [
          PracticeStep(
              title: "Close",
              cue:
                  "Sit with your eyes open or closed. Notice a nearby sound. Let it arrive and leave without searching for its source.",
              seconds: 180),
          PracticeStep(
              title: "Far",
              cue:
                  "Notice a more distant sound if one is present. If not, stay with the quiet. Neither is a test.",
              seconds: 180),
          PracticeStep(
              title: "Together",
              cue:
                  "Allow close and distant sounds in the same field. When a story starts, gently return to the sound itself.",
              seconds: 180),
          PracticeStep(
              title: "Return",
              cue:
                  "Include the pressure of your feet and hands. Move your fingers and look around. Name one sound you had not noticed before.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "attention-trail",
        title: "The attention trail",
        subtitle: "A longer practice of noticing and returning.",
        kind: "sit",
        minutes: 18,
        level: "rough",
        aims: ["sit", "ease"],
        teaching:
            "The skill is returning, not staying perfectly focused. Each return is one repetition of the practice.",
        steps: [
          PracticeStep(
              title: "Choose an anchor",
              cue:
                  "Sit supported. Choose your feet, hands or an ordinary breath as an anchor. Pick what is easiest to sense today.",
              seconds: 270),
          PracticeStep(
              title: "Notice wandering",
              cue:
                  "When attention moves to a plan or memory, silently say thinking. Return to your anchor without finishing the thought.",
              seconds: 270),
          PracticeStep(
              title: "Allow more space",
              cue:
                  "Keep the anchor in the background while allowing sounds and sensations. If that feels busy, return to one point of contact.",
              seconds: 270),
          PracticeStep(
              title: "Choose the next step",
              cue:
                  "Let go of the exercise. Notice how you want to enter the next part of the day. Choose one small action and end slowly.",
              seconds: 270)
        ]),
    PracticeSession(
        id: "easy-tide",
        title: "Easy tide",
        subtitle: "Unforced breathing with no holds.",
        kind: "breath",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Let breathing remain comfortable. Counts are optional guides; ordinary breathing is always an available alternative.",
        steps: [
          PracticeStep(
              title: "Arrive",
              cue:
                  "Sit supported and let breathing find its own size. Loosen the jaw. There is no need to fill the lungs.",
              seconds: 120),
          PracticeStep(
              title: "Even rhythm",
              cue:
                  "If comfortable, breathe in for three and out for three. Skip counting if it creates effort. Return to a natural rhythm whenever needed.",
              seconds: 120),
          PracticeStep(
              title: "Release counting",
              cue:
                  "Stop counting. Notice the place where the breath is easiest to feel: nose, ribs or belly. Let that be enough.",
              seconds: 120),
          PracticeStep(
              title: "Rest",
              cue:
                  "Keep the breath ordinary. Notice your surroundings and move the hands before finishing.",
              seconds: 120)
        ]),
    PracticeSession(
        id: "evening-inventory",
        title: "Evening inventory",
        subtitle: "Notice the day without carrying all of it.",
        kind: "sleep",
        minutes: 12,
        level: "smooth",
        aims: ["sleep", "ease"],
        teaching:
            "Lie down or sit comfortably. This quiet lesson gives attention a few simple places to rest.",
        steps: [
          PracticeStep(
              title: "Support beneath you",
              cue:
                  "Notice the bed or chair beneath you. Let one area of the body feel supported, even if other areas remain busy.",
              seconds: 180),
          PracticeStep(
              title: "One ordinary moment",
              cue:
                  "Recall a small ordinary moment: a cup, a doorway, a patch of light. Let it remain simple rather than reviewing the whole day.",
              seconds: 180),
          PracticeStep(
              title: "Leave a task",
              cue:
                  "Name one unfinished task. Remind yourself it can have a time tomorrow. Return to the feeling of support when the task comes back.",
              seconds: 180),
          PracticeStep(
              title: "No more inventory",
              cue:
                  "Release the review. Stay with the room as it is. There is no need to complete another exercise tonight.",
              seconds: 180)
        ]),
    PracticeSession(
        id: "moss-rest",
        title: "Moss rest",
        subtitle: "A slow body scan, from contact to quiet.",
        kind: "sleep",
        minutes: 18,
        level: "smooth",
        aims: ["sleep"],
        teaching:
            "A supported body scan with no demand to relax. Stay in a position you can leave or adjust easily.",
        steps: [
          PracticeStep(
              title: "Lower body",
              cue:
                  "Rest on your side or back. Notice feet, calves and thighs in turn. Feel contact more than effort. Adjust your position as needed.",
              seconds: 270),
          PracticeStep(
              title: "Middle body",
              cue:
                  "Notice the hips, back and ribs. Let the surface carry your weight. No part needs to feel a particular way.",
              seconds: 270),
          PracticeStep(
              title: "Upper body",
              cue:
                  "Move attention to hands, arms, shoulders and face. Let the tongue rest comfortably. Allow your breathing to remain ordinary.",
              seconds: 270),
          PracticeStep(
              title: "Whole body",
              cue:
                  "Feel the body as one resting shape. Drop the sequence and let attention wander gently. You may finish or continue resting.",
              seconds: 270)
        ])
  ];
}
