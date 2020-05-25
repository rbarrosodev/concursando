namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      show_spinner("Cadastrando o admin padrão...") {%x(rails dev:add_default_admin)}
      show_spinner("Cadastrando o user padrão...") {%x(rails dev:add_default_user)}
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end 
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(email: 'adm@rodrigo.com', password: 'digorxlive', password_confirmation: 'digorxlive')
  end
  
  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(email: 'user@rodrigo.com', password: '123456', password_confirmation: '123456')
  end
  
  private
      
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}...", format: :pulse)
    spinner.auto_spin
    yield
    spinner.success("#{msg_end}")
  end

end