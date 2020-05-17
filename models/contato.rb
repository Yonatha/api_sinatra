class Contato
  include Mongoid::Document

  field :nome, type: String
  field :telefone, type: Interrupt

  validates :nome, presence: true
  validates :telefone, presence: true

  index({nome: 'text'})
  index({telefone: 1}, {unique: true, name: "telefone_index"})

  scope :nome, -> (nome) { where(:nome => /^#{nome}/) }
  scope :telefone, -> (telefone) { where(:telefone => telefone) }

end