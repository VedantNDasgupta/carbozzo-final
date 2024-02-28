class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}

final List<QuizQuestion> quizData = [
  QuizQuestion(
    question: 'Renewable energy source?',
    options: ['Solar', 'Oil'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Main cause of air pollution?',
    options: ['Emissions', 'Plastics'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Recyclable material?',
    options: ['Glass', 'Styrofoam'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Renewable resource?',
    options: ['Wind', 'Natural gas'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Cause of deforestation?',
    options: ['Logging', 'Reforestation'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Sustainable fishing method?',
    options: ['Aquaculture', 'Overfishing'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Greenhouse gas?',
    options: ['Methane', 'Fresh air'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Polluting vehicle fuel?',
    options: ['Diesel', 'Hydrogen'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Harmful chemical in oceans?',
    options: ['Mercury', 'Algae'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Environmental pollutant?',
    options: ['Microplastics', 'Compost'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Greenhouse gas emission?',
    options: ['Carbon dioxide', 'Oxygen'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Sustainable packaging material?',
    options: ['Biodegradable', 'Styrofoam'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Non-renewable energy source?',
    options: ['Coal', 'Geothermal'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Main cause of soil erosion?',
    options: ['Deforestation', 'Terracing'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Carbon-neutral energy source?',
    options: ['Hydroelectric', 'Natural gas'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Eco-friendly building material?',
    options: ['Bamboo', 'Concrete'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Biodegradable waste?',
    options: ['Paper', 'Plastic'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Pollutant in marine ecosystems?',
    options: ['Oil spills', 'Seaweed'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Eco-friendly household cleaner?',
    options: ['Vinegar', 'Bleach'],
    correctOptionIndex: 0,
  ),
];
