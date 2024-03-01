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
    options: ['Plastics', 'Emissions'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Recyclable material?',
    options: ['Glass', 'Styrofoam'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Renewable resource?',
    options: ['Natural gas', 'Wind'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Cause of deforestation?',
    options: ['Reforestation', 'Logging'],
    correctOptionIndex: 1,
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
    options: ['Hydrogen', 'Diesel'],
    correctOptionIndex: 1,
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
    options: ['Oxygen', 'Carbon dioxide'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Sustainable packaging material?',
    options: ['Biodegradable', 'Styrofoam'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Non-renewable energy source?',
    options: ['Geothermal', 'Coal'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Main cause of soil erosion?',
    options: ['Terracing', 'Deforestation'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Carbon-neutral energy source?',
    options: ['Natural gas', 'Hydroelectric'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Eco-friendly building material?',
    options: ['Bamboo', 'Concrete'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Biodegradable waste?',
    options: ['Plastic', 'Paper'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Pollutant in marine ecosystems?',
    options: ['Seaweed', 'Oil spills'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Eco-friendly household cleaner?',
    options: ['Bleach', 'Vinegar'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Reducing ___ waste helps the environment.',
    options: ['Paper', 'Plastic'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Solar panels generate ___ energy.',
    options: ['Renewable', 'Dirty'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Pollution from factories contributes to ___ change.',
    options: ['Climate', 'Positive'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Driving less reduces ___ emissions.',
    options: ['Metal', 'Carbon'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Recycling helps ___ resources.',
    options: ['Waste', 'Conserve'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Planting trees helps combat ___ change.',
    options: ['Invisible', 'Climate'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Composting reduces food ___.',
    options: ['Waste', 'Drink'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Energy-efficient appliances save ___.',
    options: ['Energy', 'Time'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Air ___ can cause respiratory problems.',
    options: ['Pollution', 'Clear'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Using public transportation reduces ___ emissions.',
    options: ['Gold', 'Carbon'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Using ___ bags instead of plastic helps the environment.',
    options: ['Disposable', 'Reusable'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: '___ dioxide is a greenhouse gas.',
    options: ['Oxygen', 'Carbon'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: 'Harmful chemicals can leach into soil from ___ sites.',
    options: ['Landfill', 'Garden'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Burning fossil fuels releases ___ gases.',
    options: ['Greenhouse', 'Blue'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: '___ farming helps preserve biodiversity.',
    options: ['Organic', 'Synthetic'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question: 'Buying locally reduces ___ emissions.',
    options: ['Water', 'Transport'],
    correctOptionIndex: 1,
  ),
  QuizQuestion(
    question: '___ is a renewable energy source.',
    options: ['Wind', 'Nuclear'],
    correctOptionIndex: 0,
  ),
  QuizQuestion(
    question:
        '___ gas is used as a refrigerant and contributes to ozone depletion.',
    options: ['CFC', 'CO2'],
    correctOptionIndex: 0,
  ),
];

// Shuffling the list of questions
void shuffleQuestions() {
  quizData.shuffle();
}

// Call this function to shuffle questions before displaying
void displayRandomizedQuestions() {
  shuffleQuestions();
  for (var i = 0; i < quizData.length; i++) {
    print("Question ${i + 1}: ${quizData[i].question}");
  }
}
