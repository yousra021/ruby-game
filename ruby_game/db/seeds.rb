puts "🌱 Demarrage du seed..."

# === UTILISATEURS ===
mj = User.find_or_create_by!(email: "mj@zombieworld.com") do |u|
  u.username = "MJ"
  u.password = "password123"
  u.is_gamemaster = true
end

player = User.find_or_create_by!(email: "joueur@zombieworld.com") do |u|
  u.username = "joueur1"
  u.password = "password123"
  u.is_gamemaster = false
end

# === PERSONNAGE ===
char = Character.find_or_create_by!(name: "Alex") do |c|
  c.role = "Eclaireur"
  c.level = 1
  c.experience = 0
  c.health = 20
  c.strength = 10
  c.available_points = 5
  c.user = player
end

# === EQUIPEMENT DE BASE ===
knife = Equipment.find_or_create_by!(name: "Couteau rouille", equipment_type: "weapon") do |eq|
  eq.bonus_force = 1
  eq.description = "Un vieux couteau recupere sur un rodeur."
end

char.update!(weapon: knife)
InventoryItem.find_or_create_by!(character: char, equipment: knife, equipped: true)

# === QUETES DE BASE ===
default_quests = [
  {
    title: "Sauver les refugies",
    description: "Retrouvez et aidez les civils bloques dans la zone rouge.",
    steps: [
      { desc: "Forcer l'entree du batiment.", q: "Quel outil ouvre une porte ?", a: "Pied-de-biche", wa: ["Cle", "Tournevis"], npc: "Rodeur du hall" },
      { desc: "Reperer les survivants dans le batiment.", q: "Ou se cachent les civils ?", a: "Sous-sol", wa: ["Toit", "Cuisine"], npc: "Hurleur infecte" }
    ]
  },
  {
    title: "Exploration du tunnel",
    description: "Trouver un chemin sur a travers le tunnel effondre.",
    steps: [
      { desc: "Trouver un passage sur.", q: "Quel chemin est securise ?", a: "Cote droit", wa: ["Cote gauche", "Centre"], npc: "Rat mutant" },
      { desc: "Eviter un piege tendu.", q: "Quel fil couper ?", a: "Le bleu", wa: ["Le rouge", "Le vert"], npc: "Piegeur fou" }
    ]
  },
  {
    title: "Le generateur",
    description: "Reparer le generateur pour redonner de l'electricite.",
    steps: [
      { desc: "Identifier la panne.", q: "Quel outil utiliser ?", a: "Multimetre", wa: ["Marteau", "Scie"], npc: "Technicien zombifie" },
      { desc: "Proteger l'equipe pendant la reparation.", q: "Quel est le role du joueur ?", a: "Proteger", wa: ["Reparer", "Observer"], npc: "Infecte rapide" }
    ]
  }
]

# === QUETES GENERÉES (10)
10.times do |i|
  default_quests << {
    title: "Mission #{i + 1}",
    description: "Objectif secondaire dans la zone #{i + 1}",
    steps: [
      {
        desc: "Localiser un point stratégique.",
        q: "Quel est le point clé du secteur #{i + 1} ?",
        a: "Zone A",
        wa: ["Zone B", "Zone C"],
        npc: "Zombie errant #{i + 1}"
      },
      {
        desc: "Eliminer la menace principale.",
        q: "Quel est le point faible du monstre ?",
        a: "La tête",
        wa: ["Les bras", "Le dos"],
        npc: "Infecté #{i + 1}"
      }
    ]
  }
end

default_quests.each do |q_data|
  quest = Quest.find_or_create_by!(title: q_data[:title]) do |q|
    q.description = q_data[:description]
    q.active = true
    q.creator = mj
  end

  q_data[:steps].each do |step_data|
    step = QuestStep.create!(
      quest: quest,
      description: step_data[:desc],
      base_experience: 30
    )

    riddle = Riddle.create!(
      quest_step: step,
      question: step_data[:q],
      correct_answer: step_data[:a],
      wrong_answers: step_data[:wa].to_json
    )

    npc = Npc.create!(
      quest_step: step,
      name: step_data[:npc],
      health: rand(25..40),
      strength: rand(5..8)
    )

    step.update!(has_riddle: true, has_combat: true, riddle: riddle, npc: npc)
  end
end

puts "✅ Quetes creees avec succes."

# === EQUIPEMENTS ===
puts "📦 Ajout des equipements..."

equipment_data = [
  { name: "Couteau", equipment_type: "weapon", bonus_force: 1, bonus_xp: 1, image: "knife.png", description: "Petit couteau de survie." },
  { name: "Batte cloutee", equipment_type: "weapon", bonus_force: 3, bonus_xp: 2, image: "bat.png", description: "Batte avec clous rouilles." },
  { name: "Machette", equipment_type: "weapon", bonus_force: 4, bonus_xp: 3, image: "machete.png", description: "Lame tranchante." },
  { name: "Arbalete", equipment_type: "weapon", bonus_force: 2, bonus_xp: 2, image: "crossbow.png", description: "Arme silencieuse." },
  { name: "Fusil a pompe", equipment_type: "weapon", bonus_force: 5, bonus_xp: 4, image: "shotgun.png", description: "Tres puissant a courte portee." },

  { name: "T-shirt", equipment_type: "top", image: "tshirt.png", description: "Confortable." },
  { name: "Blouson en cuir", equipment_type: "top", bonus_pv: 2, bonus_xp: 1, image: "leather_jacket.png", description: "Protege bien." },
  { name: "Blouson renforce", equipment_type: "top", bonus_pv: 3, bonus_instinct: -1, bonus_xp: 2, image: "reinforced_jacket.png", description: "Tres solide." },
  { name: "Gilet tactique", equipment_type: "top", bonus_force: 1, bonus_pv: 1, bonus_xp: 1, image: "tactical_vest.png", description: "Equilibre." },

  { name: "Jean", equipment_type: "bottom", image: "jeans.png", description: "Classique." },
  { name: "Cargo", equipment_type: "bottom", bonus_pv: 1, bonus_xp: 1, image: "cargo_pants.png", description: "Beaucoup de poches." },
  { name: "Pantalon blinde", equipment_type: "bottom", bonus_pv: 3, bonus_instinct: -1, bonus_xp: 2, image: "armored_pants.png", description: "Tres protecteur." },

  { name: "Radio", equipment_type: "accessory", bonus_xp: 5, image: "radio.png", description: "Capte des infos utiles." },
  { name: "Lampe frontale", equipment_type: "accessory", bonus_instinct: 1, image: "headlamp.png", description: "Pour explorer." },
  { name: "Talkie Walkie", equipment_type: "accessory", bonus_xp: 1, image: "walkie_talkie.png", description: "Communication courte distance." },
  { name: "Sac a dos", equipment_type: "accessory", image: "backpack.png", description: "Transporter plus." },
  { name: "Gants de combat", equipment_type: "accessory", bonus_force: 1, bonus_xp: 1, image: "combat_gloves.png", description: "Bonne prise." },

  { name: "Medikit", equipment_type: "consumable", bonus_pv: 10, image: "medkit.png", description: "Soigne." },
  { name: "Adrenaline", equipment_type: "consumable", bonus_force: 2, image: "adrenaline.png", description: "Booste la force." },
  { name: "Cocktail molotov", equipment_type: "consumable", bonus_force: 5, image: "molotov.png", description: "Inflige des degats de zone." },
]

equipment_data.each do |eq|
  item = Equipment.find_or_initialize_by(name: eq[:name], equipment_type: eq[:equipment_type])
  item.assign_attributes(
    bonus_force: eq[:bonus_force] || 0,
    bonus_pv: eq[:bonus_pv] || 0,
    bonus_xp: eq[:bonus_xp] || 0,
    bonus_instinct: eq[:bonus_instinct] || 0,
    description: eq[:description]
  )
  item.save!

  if eq[:image].present? && !item.image.attached?
    image_path = Rails.root.join("app/assets/images/equipment/#{eq[:image]}")
    if File.exist?(image_path)
      item.image.attach(io: File.open(image_path), filename: eq[:image])
      puts "🖼️ Image attachee a #{eq[:name]}"
    else
      puts "⚠️ Image introuvable pour #{eq[:name]}: #{eq[:image]}"
    end
  end
end

puts "🧟 Ajout des zombies de base..."

zombie_names = [
  { name: "Zombie Grincheux", avatar: "zombie1.png" },
  { name: "Marcheur Puant", avatar: "zombie2.png" },
  { name: "LErrant Aveugle", avatar: "zombie3.png" },
  { name: "La Machoire Cassee", avatar: "zombie4.png" },
  { name: "Le Hurleur", avatar: "zombie5.png" },
  { name: "Zombie de lHopital", avatar: "zombie6.png" },
  { name: "Le Rampant Sanglant", avatar: "zombie7.png" },
  { name: "Ex-Militaire Infecte", avatar: "zombie8.png" }
]

Npc.where(name: zombie_names.map { |z| z[:name] }).destroy_all

zombie_names.each do |z|
  npc = Npc.find_or_initialize_by(name: z[:name])
  npc.health = rand(25..40) if npc.health.nil?
  npc.strength = rand(5..8) if npc.strength.nil?
  npc.save!

  if z[:avatar].present? && !npc.avatar.attached?
    avatar_path = Rails.root.join("app/assets/images/npcs/#{z[:avatar]}")
    if File.exist?(avatar_path)
      npc.avatar.attach(io: File.open(avatar_path), filename: z[:avatar])
      puts "🖼️ Avatar attache a #{z[:name]}"
    else
      puts "⚠️ Avatar introuvable pour #{z[:name]}: #{z[:avatar]}"
    end
  end
end

puts "✅ Zombies + avatars ajoutes avec succes."
