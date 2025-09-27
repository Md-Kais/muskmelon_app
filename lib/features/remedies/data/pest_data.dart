// lib/features/remedies/data/pest_data.dart
import '../models/pest.dart';

final List<Pest> pestsData = [
  Pest(
    id: 'fruit_fly',
    nameBn: 'ফলের ছিদ্রকারী পোকা',
    nameEn: 'Melon Fruit Fly (Bactrocera cucurbitae)',
    shortSymptomBn: 'ফলে ছোট ছিদ্র, ভিতরে পচা',
    shortSymptomEn: 'Tiny oviposition punctures; fruit rots',
    imageAsset: 'assets/pests/melon_fly.jpg',
    symptomsBn:
        'ডিম পাড়ার দাগ/ছিদ্র দেখা যায়, রস ঝরে, ফল পচে যায়। বর্ডার/চারপাশে প্রাপ্তবয়স্ক মাছি বেশি দেখা যায়।',
    symptomsEn:
        'Small punctures and oozing; larvae cause internal rot. Adults often aggregate on borders.',
    preventionBn:
        'আক্রান্ত/পড়া ফল সংগ্রহ ও ধ্বংস, ক্ষেতের চারপাশে কিউ-লিউর ট্র্যাপ ৩–৪টি/ক্ষেত, ফল ব্যাগিং, বর্ডারে প্রোটিন বেট স্প্রে।',
    preventionEn:
        'Field sanitation (remove infested fruits), deploy cue-lure traps (3–4 per field), bag fruits, border protein bait sprays.',
    safetyBn:
        'বেট/স্প্রে শিশু ও মাছ/মৌমাছির কাছ থেকে দূরে রাখুন। সবসময় লেবেল মানুন।',
    safetyEn:
        'Keep baits/sprays away from children, bees, fish; always follow the label.',
    organic: [
      Dose(
        label: 'GF-120 NF (Spinosad bait)',
        amount:
            '10–20 fl oz/acre; dilute 1:1.5–1:5 (product:water); large droplets (4–6 mm)',
        notes:
            'বর্ডার/স্ট্রিপে স্পট-স্প্রে; ৭–১০ দিন পর পর পুনরাবৃত্তি; ফল ভেজানোর প্রয়োজন নেই',
        sources: [
          // Label + tech bulletins
          'https://www3.epa.gov/pesticides/chem_search/ppls/062719-00498-20030401.pdf',
          'https://s3-us-west-1.amazonaws.com/agrian-cg-fs1-production/pdfs/GF-120_NF_Naturalyte_Fruit_Fly_Bait_2EE2e.pdf',
          'https://pendletonny.us/wp-content/uploads/2020/02/GF120NF-Special-Need-Label.pdf',
        ],
      ),
    ],
    chemical: const [],
    references: [
      // Cue-lure / Bangladesh success stories
      'https://ipmil.cired.vt.edu/wp-content/uploads/2019/02/Fruit-Fly-Pheromone-Trap-Success-Story.pdf',
      'https://ipmil.cired.vt.edu/wp-content/uploads/2018/07/Fruit-Fly-Control-on-Cucurbit-Crops-Brochure-2.pdf',
    ],
  ),

  Pest(
    id: 'downy_mildew',
    nameBn: 'ডাউনি মিলডিউ',
    nameEn: 'Downy mildew (Pseudoperonospora cubensis)',
    shortSymptomBn: 'পাতায় কোণাকৃতি হলুদ দাগ',
    shortSymptomEn: 'Angular yellow lesions, grey/purple underside',
    imageAsset: 'assets/pests/downy_mildew.jpg',
    symptomsBn:
        'পাতার ওপর কোণাকৃতি হলুদ দাগ, পাতার নিচে ধূসর/বেগুনি ফাজ—দ্রুত পাতা নষ্ট।',
    symptomsEn:
        'Angular yellow spots bounded by veins; dark sporulation underside; rapid defoliation.',
    preventionBn:
        'স্কাউটিং, ড্রিপ সেচ/ভেজা পাতা এড়ানো, রোগপ্রবণ আবহাওয়ায় প্রিভেন্টিভ স্প্রে শুরু, ফসল পরিবর্তন।',
    preventionEn:
        'Scout often; reduce leaf wetness; start preventives when conditions favor disease; rotate crops.',
    safetyBn: 'একই FRAC বারবার দেবেন না; লেবেল ও PHI/REI মানুন।',
    safetyEn: 'Rotate FRAC groups; observe PHI/REI and label limits.',
    organic: [
      Dose(
        label: 'Chlorothalonil/Mancozeb (protectant)',
        amount: 'Label rates (e.g., chlorothalonil 1.4–1.8 lb/A ranges exist)',
        notes: 'প্রতিরোধে সহায়ক; একা জোরালো আক্রমণে দুর্বল',
        sources: ['https://ipm.ucanr.edu/agriculture/cucurbits/downy-mildew/'],
      ),
    ],
    chemical: [
      Dose(
        label: 'Cyazofamid (Ranman 400SC)',
        amount: '2.1–2.75 fl oz/acre',
        notes: 'মৌসুমে সর্বোচ্চ আবেদন সীমা মানুন; protectant যোগ করুন',
        sources: [
          'https://ipm.ucanr.edu/agriculture/cucurbits/downy-mildew/',
          'https://www3.epa.gov/pesticides/chem_search/ppls/071512-00003-20200326.pdf',
        ],
      ),
      Dose(
        label: 'Oxathiapiprolin + Chlorothalonil (Orondis Opti 3.37SC)',
        amount: '1.75–2.5 fl oz/acre (state guide example)',
        notes: 'শক্তিশালী; কড়াকড়ি রোটেশন দরকার; স্থানীয় লেবেল মিলিয়ে নিন',
        sources: [
          'https://www.uaex.uada.edu/publications/pdf/mp154/2021/Vegetable-Diseases.pdf',
          'https://www3.epa.gov/pesticides/chem_search/ppls/000100-01591-20211108.pdf',
        ],
      ),
    ],
    references: [
      'https://content.ces.ncsu.edu/cucurbit-downy-mildew',
      'https://ipm.ucanr.edu/agriculture/cucurbits/downy-mildew/',
      'https://www.uaex.uada.edu/publications/pdf/mp154/2021/Vegetable-Diseases.pdf',
    ],
  ),

  Pest(
    id: 'powdery_mildew',
    nameBn: 'পাউডারী মিলডিউ',
    nameEn: 'Powdery mildew (Podosphaera xanthii etc.)',
    shortSymptomBn: 'পাতায় সাদা গুঁড়ো আস্তরণ',
    shortSymptomEn: 'White powdery growth on leaves',
    imageAsset: 'assets/pests/powdery_mildew.jpg',
    symptomsBn:
        'পাতায় সাদা আস্তরণ, পাতার রং ফ্যাকাসে, ফলন কমে।',
    symptomsEn:
        'White colonies on leaves; chlorosis; yield reduction.',
    preventionBn:
        'অতিরিক্ত নাইট্রোজেন এড়ান; বায়ু চলাচল; আগেভাগে প্রতিরোধী স্প্রে।',
    preventionEn:
        'Avoid excess N; improve airflow; start preventives early.',
    safetyBn: 'গরম/রোদে তেল/সালফার সাবধানে।',
    safetyEn: 'Avoid oils/sulfur in heat to reduce phytotoxicity.',
    organic: [
      Dose(
        label: 'Potassium bicarbonate',
        amount: '2.5–5 lb/acre (≈3–6 g/L @ 100 gal/A)',
        notes: 'ইরাডিক্যান্ট/প্রিভেন্টিভ—প্রাথমিক সংক্রমণে ভালো',
        sources: [
          'https://ipm.ucanr.edu/agriculture/cucurbits/powdery-mildew/',
          'https://projectblue.blob.core.windows.net/media/Default/Research%20Papers/Horticulture/CP/CP%2048%20powdery%20mildew%20control%202005.pdf',
        ],
      ),
      Dose(
        label: 'JMS Stylet-Oil (mineral oil)',
        amount: '≈0.75% v/v (3 qt/100 gal)',
        notes: 'পাতা ভালোভাবে ভেজান; অতিরিক্ত গরমে স্প্রে নয়',
        sources: [
          'https://www3.epa.gov/pesticides/chem_search/ppls/065564-00001-19990428.pdf',
          'https://cdn.arbico-organics.com/downloads/stylet-oil-label.pdf',
        ],
      ),
    ],
    chemical: const [],
    references: [
      'https://ipm.ucanr.edu/agriculture/cucurbits/powdery-mildew/',
    ],
  ),

  Pest(
    id: 'aphids',
    nameBn: 'জাব পোকা',
    nameEn: 'Aphids',
    shortSymptomBn: 'পাতার নিচে দলবদ্ধ নরম পোকা',
    shortSymptomEn: 'Colonies under leaves; honeydew & sooty mold',
    imageAsset: 'assets/pests/aphid.jpg',
    symptomsBn:
        'পাতা কুঁচকে যায়; হানিডিউ; ভাইরাস বিস্তার।',
    symptomsEn:
        'Leaf curling, honeydew, virus spread.',
    preventionBn:
        'প্রতিফলক সিলভার মাল্চ/রো-কভার; আগাছা দমন; উপকারী পোকা সংরক্ষণ।',
    preventionEn:
        'Reflective silver mulch or row covers; weed control; conserve natural enemies.',
    safetyBn: 'সাবান/তেল গরমে বা রোদে না; লেবেল মানুন।',
    safetyEn: 'Avoid soap/oil in heat or full sun; follow labels.',
    organic: [
      Dose(
        label: 'Insecticidal soap',
        amount: '1–2% (10–20 mL/L)',
        notes: 'পাতার উল্টো দিকে ভিজে যাওয়া আবশ্যক',
        sources: ['https://hgic.clemson.edu/factsheet/insecticidal-soaps-for-garden-pest-control/'],
      ),
      Dose(
        label: 'JMS Stylet-Oil',
        amount: '≈0.75% v/v',
        notes: 'ভাইরাস সংক্রমণ ধীর করতে সাহায্য করে (stylet interference)',
        sources: [
          'https://cdn.arbico-organics.com/downloads/stylet-oil-label.pdf',
          'https://ipm.ucanr.edu/agriculture/cucurbits/melon-aphid/',
        ],
      ),
    ],
    chemical: const [],
    references: [
      'https://ipm.ucanr.edu/agriculture/cucurbits/melon-aphid/',
      'https://ipm.ucanr.edu/PMG/PESTNOTES/pn7404.html',
      'https://ipm.ucanr.edu/agriculture/floriculture-and-ornamental-nurseries/reflective-mulches/',
    ],
  ),

  Pest(
    id: 'mosaic_virus',
    nameBn: 'মোজাইক ভাইরাস',
    nameEn: 'Mosaic viruses (CMV/WMV/ZYMV)',
    shortSymptomBn: 'পাতায় হলুদ মোজাইক/বিকৃতি',
    shortSymptomEn: 'Yellow mosaic, distortion, stunting',
    imageAsset: 'assets/pests/mosaic_virus.jpg',
    symptomsBn:
        'পাতায় হলুদ-সবুজ মোজাইক দাগ, বিকৃতি; ফল বিকল।',
    symptomsEn:
        'Mosaic patterning, distortion; malformed fruit.',
    preventionBn:
        'ভাইরাসের ওষুধ নেই—প্রতিরোধ: সিলভার মাল্চ, স্টাইলেট-অয়েল, জাব পোকা দমন, রুগ্ন গাছ তুলে ফেলা, পরিষ্কার বীজ।',
    preventionEn:
        'No cures: use reflective mulches, mineral oil program, aphid management, rogue infected plants, clean seed.',
    safetyBn: 'প্রতিষেধক/তেল গরমে সাবধানে; হাতিয়ার জীবাণুমুক্ত রাখুন।',
    safetyEn: 'Avoid oils in heat; sanitize tools.',
    organic: [
      Dose(
        label: 'Mineral oil (JMS Stylet-Oil)',
        amount: '≈0.75% v/v; weekly–twice weekly early',
        notes: 'aphid-mediated virus transmission কমাতে সহায়ক',
        sources: [
          'https://www3.epa.gov/pesticides/chem_search/ppls/065564-00001-19990428.pdf',
        ],
      ),
    ],
    chemical: const [],
    references: [
      'https://ipm.ucanr.edu/agriculture/cucurbits/planting/',
      'https://ipm.ucanr.edu/PMG/PESTNOTES/pn7404.html',
    ],
  ),
];
