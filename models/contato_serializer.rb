class ContatoSerializer
  def initialize contato
    @contato = contato
  end

  def as_json(*)
    contato = {
        id: @contato.id.to_s,
        nome: @contato.nome,
        telefone: @contato.telefone,
    }
    contato[:errors] = @contato.errors if @contato.errors.any?
    contato
  end
end