# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "open-uri"

p "delete existing users and depenbencies"
JobOffer.destroy_all
KeyFigure.destroy_all
Competitor.destroy_all
User.destroy_all
Company.destroy_all
Message.destroy_all

p "generate users"
ai = Company.create!(name: "Air Indemnité")
p ai
t = User.create!(name: "thierry", email: "thierry@gmail.com", password: "password", admin: true, company_id: ai.id)
f = User.create!(name: "florian", email: "florian@gmail.com", password: "password", admin: true, company_id: ai.id)
j = User.create!(name: "jerome", email: "jerome@gmail.com", password: "password", admin: true, company_id: ai.id)
l = User.create!(name: "lea", email: "lea@gmail.com", password: "password", company_id: ai.id)
e = User.create!(name: "elsa", email: "elsa@gmail.com", password: "password", company_id: ai.id)
g = User.create!(name: "gregoire", email: "gregoire@gmail.com", password: "password", company_id: ai.id)


j_githubphoto = URI.open("https://avatars1.githubusercontent.com/u/71142027?s=400&u=30e4781ac2d83e513320c764d5a0e0cad976cda1&v=4")
j.photo.attach(io: j_githubphoto, filename: 'javatar.png', content_type: 'image/png')
f_githubphoto = URI.open("https://avatars0.githubusercontent.com/u/50924405?s=400&u=8c9c5b5a760cc4786c72b0bdd5dc275701224d5d&v=4")
f.photo.attach(io: f_githubphoto, filename: 'javatar.png', content_type: 'image/png')
t_githubphoto = URI.open("https://avatars1.githubusercontent.com/u/68321525?s=460&u=7b8f17f8ee4daed9e1ba5f1b5b35fcc51ddd4418&v=4")
t.photo.attach(io: t_githubphoto, filename: 'javatar.png', content_type: 'image/png')
l_githubphoto = URI.open("https://avatars2.githubusercontent.com/u/70152774?s=400&u=6c72c26334acbe17330e1f79f3f6f41225ab4c17&v=4")
l.photo.attach(io: l_githubphoto, filename: 'javatar.png', content_type: 'image/png')
e_githubphoto = URI.open("https://avatars3.githubusercontent.com/u/60131956?s=400&u=e0ead99f878384c4b35360eb4e13f561d99e0110&v=4")
e.photo.attach(io: e_githubphoto, filename: 'javatar.png', content_type: 'image/png')
g_githubphoto = URI.open("https://avatars0.githubusercontent.com/u/17796594?s=400&u=f6de9d96550d08d6272ed71df20e485f45bcfa83&v=4
")
g.photo.attach(io: g_githubphoto, filename: 'javatar.png', content_type: 'image/png')

p "generate competitors for Air Indemnité"
siren = [
  "820867877",
  "814428785",
  "839793791",
  "822183711",
  "817618051",
  "832146237",
  "820557254",
  "751610015",
  "501170187",
  "827748518",
  "819440371",
  "819531864",
  "803147446",
  "572079150"
]
siren.each do |siren|
  competitor = Competitor.new(siren: siren)
  competitor.company = Company.find_by(name: "Air Indemnité")
  competitor.save
  InfogreffeJob.perform_later(competitor.id)
end

p "generate message"


Message.create(user_id: f.id, category: "HR", content: "Ils viennent d'embaucher le head of acquisition de Captain Contrat ! (FYI SIREN: 798098430)" , competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 2.days - 3.hours - 26.minutes)
Message.create(user_id: l.id, category: "HR", content: "Des départs à prévoir dans leur équipe tech, visiblement c''est pas la joie avec leur nouveau CTO", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 4.days - 2.hours - 38.minutes)
Message.create(user_id: l.id, category: "HR", content: "ils sont passés sur linkedin recruiter et contactent pas mal de nos devs ! on peut chasser chez eux", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 5.days - 4.minutes)
Message.create(user_id: j.id, category: "ID", content: "Possibilité d'une levée de fonds en janvier prochain pour s'étendre à l'échelle européenne", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 1.days - 1.hours)
Message.create(user_id: g.id, category: "ID", content: "Yes, Xavier Niel vient de mettre un petit ticket dans la boite d'ailleurs ;)", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 30.days - 2.hours - 35.minutes)
Message.create(user_id: e.id, category: "ID", content: "Je viens de voir que c'était Alexandre Grux qui a créé ça, il était pas dans ta promo Grégoire?", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 31.days - 4.hours - 12.minutes)
Message.create(user_id: f.id, category: "ID", content: "Je viens de le rajouter dans la base, ils ont l'air d'avoir un projet solide", competitor_id: Competitor.find_by(siren: "832146237").id, created_at: Time.zone.now - 62.days - 3.hours - 40.minutes)


p "finishing seed"
