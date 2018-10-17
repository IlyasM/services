defmodule Api.MailWorker do
  import Swoosh.Email
  use Phoenix.Swoosh, view: ApiWeb.EmailView, layout: {ApiWeb.LayoutView, :email}

  def send_code(email, code) do
    new()
    |> from("ilyaskz7@gmail.com")
    |> to(email)
    |> subject("Код для регистрации #{code}")
    # |> render_body("confirm.html", %{code: code})
    |> html_body(
      "<h2>Мы рады Вас видеть!</h2><p>Ваш код действителен в течение 30 минут.</p><h3>#{code}</h3>"
    )
    |> Api.Mailer.deliver()
  end
end
