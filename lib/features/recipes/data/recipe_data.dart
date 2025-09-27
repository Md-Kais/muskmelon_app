import '../models/recipe.dart';

final List<Recipe> recipesData = [
  // 🥤 বাঙ্গির জুস
  Recipe(
    id: 'juice',
    titleBn: 'বাঙ্গির জুস',
    titleEn: 'Muskmelon Juice',
    imageAsset: 'assets/recipes/juice.jpg',
    ingredientsBn: [
      'বাঙ্গি (ফlesh) – ৩০০ গ্রাম',
      'ঠাণ্ডা পানি – ২০০ মি.লি.',
      'লেবুর রস – ১০ মি.লি. (ঐচ্ছিক)',
      'মধু/চিনি – স্বাদমতো (ঐচ্ছিক)',
      'এক চিমটি লবণ',
    ],
    ingredientsEn: [
      'Muskmelon flesh – 300 g',
      'Chilled water – 200 ml',
      'Lime juice – 10 ml (optional)',
      'Honey/sugar – to taste (optional)',
      'Pinch of salt',
    ],
    stepsBn: [
      'ব্লেন্ডারে বাঙ্গি, পানি, লেবুর রস ও লবণ দিন।',
      'মসৃণ না হওয়া পর্যন্ত ব্লেন্ড করুন; খুব ঘন হলে আরও পানি দিন।',
      'চাইলে ছেঁকে বরফসহ পরিবেশন করুন; স্বাদমতো মধু দিন।',
    ],
    stepsEn: [
      'Add melon, water, lime, and salt to a blender.',
      'Blend until smooth; thin with more water if needed.',
      'Strain (optional) and serve over ice; sweeten to taste.',
    ],
    // Per serving ≈ 150 g melon
    nutritionPerServing: const Nutrition(
      calories: 51,
      carbs: 12.2,
      protein: 0.6,
      fat: 0.1,
      fiber: 1.4,
      potassium: 400, // mg
      vitaminC: 55.0, // mg
    ),
    youtubeId: 'wgiUL3TuhY0', // Bengali sharbat
    refs: [
      // Nutrition refs
      'https://tools.myfooddata.com/nutrition-facts/169092/wt1',
      'https://foods.fatsecret.com/calories-nutrition/usda/cantaloupe-melons?portionamount=100.000&portionid=58596',
    ],
  ),

  // 🥗 বাঙ্গির সালাদ
  Recipe(
    id: 'salad',
    titleBn: 'বাঙ্গির সালাদ',
    titleEn: 'Muskmelon Salad',
    imageAsset: 'assets/recipes/salad.jpg',
    ingredientsBn: [
      'বাঙ্গি – ২৫০ গ্রাম কিউব',
      'শসা – ১০০ গ্রাম কিউব',
      'লেবুর রস – ১৫ মি.লি.',
      'ভাজা চিনাবাদাম – ১৫ গ্রাম (ঐচ্ছিক)',
      'পুদিনা/ধনেপাতা – ২ টেবিল চামচ কুচি',
      'লবণ–মরিচ স্বাদমতো',
    ],
    ingredientsEn: [
      'Muskmelon – 250 g cubes',
      'Cucumber – 100 g cubes',
      'Lime juice – 15 ml',
      'Roasted peanuts – 15 g (optional)',
      'Mint/coriander – 2 tbsp chopped',
      'Salt & pepper to taste',
    ],
    stepsBn: [
      'বাটিতে বাঙ্গি, শসা, পুদিনা মেশান।',
      'লেবুর রস, লবণ–মরিচ দিয়ে আস্তে নাড়ুন।',
      'চাইলে চিনাবাদাম ছিটিয়ে পরিবেশন করুন।',
    ],
    stepsEn: [
      'Combine melon, cucumber, and herbs.',
      'Dress with lime, salt, and pepper; toss gently.',
      'Sprinkle peanuts (optional) and serve.',
    ],
    // Per serving ≈ 200 g melon portion counted
    nutritionPerServing: const Nutrition(
      calories: 68,
      carbs: 16.3,
      protein: 0.8,
      fat: 0.2,
      fiber: 1.8,
      potassium: 534,
      vitaminC: 73.0,
    ),
    youtubeId: 'x4dWZPrPO3M',
    refs: [
      'https://tools.myfooddata.com/nutrition-facts/169092/wt1',
      'https://www.dietaryguidelines.gov/food-sources-potassium',
    ],
  ),

  // 🍨 বাঙ্গির মিষ্টি (দই/মধু কাপ)
  Recipe(
    id: 'sweet',
    titleBn: 'বাঙ্গির মিষ্টি',
    titleEn: 'Melon Yogurt Cups',
    imageAsset: 'assets/recipes/sweet.jpg',
    ingredientsBn: [
      'বাঙ্গি – ২০০ গ্রাম কিউব',
      'ঘন টকদই – ১৫০ গ্রাম',
      'মধু – ১–২ টেবিল চামচ (ঐচ্ছিক)',
      'পেস্তা/বাদাম – ১০ গ্রাম (ঐচ্ছিক)',
      'এক চিমটি দারুচিনি গুঁড়ো (ঐচ্ছিক)',
    ],
    ingredientsEn: [
      'Muskmelon – 200 g cubes',
      'Thick yogurt – 150 g',
      'Honey – 1–2 tbsp (optional)',
      'Pistachio/almond – 10 g (optional)',
      'Pinch of cinnamon (optional)',
    ],
    stepsBn: [
      'গ্লাসে দই দিন, উপর থেকে বাঙ্গি কিউব ছড়িয়ে দিন।',
      'মধু ছিটিয়ে বাদাম/দারুচিনি দিয়ে সাজান।',
      'ঠান্ডা করে পরিবেশন।',
    ],
    stepsEn: [
      'Layer yogurt in a cup, top with melon cubes.',
      'Drizzle honey, add nuts/cinnamon.',
      'Chill and serve.',
    ],
    // Per serving ≈ 200 g melon counted
    nutritionPerServing: const Nutrition(
      calories: 68,
      carbs: 16.3,
      protein: 0.8,
      fat: 0.2,
      fiber: 1.8,
      potassium: 534,
      vitaminC: 73.0,
    ),
    youtubeId: 'a3kVNzFi0oM', // milkshake video as related sweet; swap later if you record one
    refs: [
      'https://tools.myfooddata.com/nutrition-facts/169092/wt1',
    ],
  ),

  // 🥛 বাঙ্গির স্মুদি
  Recipe(
    id: 'smoothie',
    titleBn: 'বাঙ্গির স্মুদি',
    titleEn: 'Muskmelon Smoothie',
    imageAsset: 'assets/recipes/smoothie.jpg',
    ingredientsBn: [
      'বাঙ্গি – ২৫০ গ্রাম',
      'দুধ/দই – ১৫০ মি.লি. (লো-ফ্যাট হলে ভালো)',
      'বরফ – প্রয়োজনমতো',
      'খেজুর/মধু – স্বাদমতো (ঐচ্ছিক)',
    ],
    ingredientsEn: [
      'Muskmelon – 250 g',
      'Milk/yogurt – 150 ml (prefer low-fat)',
      'Ice – as needed',
      'Dates/honey – to taste (optional)',
    ],
    stepsBn: [
      'সব একসাথে ব্লেন্ড করুন যতক্ষণ না স্মুদ হয়।',
      'গ্লাসে ঢেলে তৎক্ষণাৎ পরিবেশন করুন।',
    ],
    stepsEn: [
      'Blend all until smooth.',
      'Pour and serve immediately.',
    ],
    // Per serving ≈ 200 g melon counted
    nutritionPerServing: const Nutrition(
      calories: 68,
      carbs: 16.3,
      protein: 0.8,
      fat: 0.2,
      fiber: 1.8,
      potassium: 534,
      vitaminC: 73.0,
    ),
    youtubeId: 'm1zV7iq9PS8',
    refs: [
      'https://tools.myfooddata.com/nutrition-facts/169092/wt1',
    ],
  ),
];
