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

j_githubphoto = URI.open("https://avatars1.githubusercontent.com/u/71142027?s=400&u=30e4781ac2d83e513320c764d5a0e0cad976cda1&v=4")
j.photo.attach(io: j_githubphoto, filename: 'javatar.png', content_type: 'image/png')
f_githubphoto = URI.open("https://avatars0.githubusercontent.com/u/50924405?s=400&u=8c9c5b5a760cc4786c72b0bdd5dc275701224d5d&v=4")
f.photo.attach(io: f_githubphoto, filename: 'javatar.png', content_type: 'image/png')
t_githubphoto = URI.open("https://avatars1.githubusercontent.com/u/68321525?s=460&u=7b8f17f8ee4daed9e1ba5f1b5b35fcc51ddd4418&v=4")
t.photo.attach(io: t_githubphoto, filename: 'javatar.png', content_type: 'image/png')

p "generate competitors for Air Indemnité"
siren = [
  "820867877",
  "814428785",
  "839793791",
  "822183711",
  "817618051",
  "798098430",
  "832146237",
  "835143751",
  "820557254",
  "751610015",
  "501170187",
  "827748518",
  "821737319",
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
