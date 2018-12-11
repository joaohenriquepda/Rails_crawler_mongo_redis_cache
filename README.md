# Webcrawler quotes

### Tecnologias usadas
- Rails 5.2 - para construção da API
- Mongoid - para o banco de persistência da API
- Redis - para o banco de cache das consultas
- Fast_JSON - gem para serialização de API - https://github.com/Netflix/fast_jsonapi
- JWT - gem para encoder e decoder de token de acesso para o sistema


### Como executar
 O projeto já conta com dois arquivos do Docker são os dockerfile e docker-compose, eles já trazem todos os containers da configuração necessária para o projeto.
 Toda componentização visou favorer o escalonamento em serviços para o projeto, assim como explorar os benefícios das técnicas de DevOps.

 Caso queira usar o Docker você precisará ter instalado o Docker e Docker-Compose. Com tudo isso já instalado só ir até a raíz do projeto e executar o comando abaixo:

 ```
 docker-compose up
 ```

Esse comando já iniciará tudo que é necessário para o projeto.

### Funcionalidades
- Registro de usuário: Para usar o projeto é necessário está registrado e ter um token de acesso válido.
- Autorização de usuário: o usuário previamente registrado deve informar email e senha para conseguir um token de acesso.
- Endpoint para pesquisa de 'quotes' por tag informada (Crawler)
- Endpoint para listagem de todos os 'quotes' registrados no sistema
- Endpoint para listagem de todos os usuários do sistema

### Funcionamento
**Todos os endpoints usados estão disponibilizados em um arquivo na raíz do projeto, foi usado o Postman para criar essa documentação**


1 - Para o projeto inicialmente será preciso realizar um registro com informações simples, esse registro é necessário para o token de acesso ao sistema. o endpoint para essa funcionalidade é **localhost:3000/users**, deve-se usar o método **POST** e seguir o seguinte modelo de informação.


```
{
	"user":
		{
			"name":"Joao Henrique",
			"email":"joaohenrique.p.almeida@gmail.com",
			"password":"joaohenrique",
			"password_confirmation":"joaohenrique"
		}

}
```

2 - Após realizado o registro de um novo usuário será necessário confirmar o usuário para receber um token de acesso ao sistema, todos os endpoints do sistema só podem ser acessados quando um token válido for informado pelo HEADER de acesso. Para obter esse token o usuário deve informar email e senha que devem ser passados na url **localhost:3000/user_auth**, utilizando o método **POST** e seguindo o seguinte modelo de dados

```{
	"email":"joaohenrique.p.almeida@gmail.com",
	"password":"joao1010"
}

```
Como retorno dessa requisição será retornado um token, ele deverá ser informado nas próximas requisições de funcionalidades do sistema.

```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjp7IiRvaWQiOiI1YzEwMTE3ZGRiODljZjAwMDEwODA5OTEifSwidG9rZW5fdHlwZSI6ImNsaWVudF9hMiIsImV4cCI6MTU0NDU3MTMyOX0.NLZRyt_vQHQpYbv669FQwnMbmshwQ18mNIzwvCEaqTA"
}
```

3 - De posse do token de acesso podemos agora usar as funcionalidades. A principal funcionalidade é de pesquisa por 'quotes' utilizando uma tag. Para isso vamos usar o endpoint **localhost:3000/quotes/:tag**, nessa url deve-se passar a tag desejada pela próproa url, além de informar pelo HEADER de acesso o token obtido no passo anterior.

```
[
    {
        "quote": "“It is better to be hated for what you are than to be loved for what you are not.”",
        "author": "André Gide",
        "author_about": "http://quotes.toscrape.com/author/Andre-Gide",
        "tags": [
            "life",
            "love"
        ]
    },
    {
        "quote": "“This life is what you make it. No matter what, you're going to mess up sometimes, it's a universal truth. But the good part is you get to decide how you're going to mess it up. Girls will be your friends - they'll act like it anyway. But just remember, some come, some go. The ones that stay with you through everything - they're your true best friends. Don't let go of them. Also remember, sisters make the best friends in the world. As for lovers, well, they'll come and go too. And baby, I hate to say it, most of them - actually pretty much all of them are going to break your heart, but you can't give up because if you give up, you'll never find your soulmate. You'll never find that half who makes you whole and that goes for everything. Just because you fail once, doesn't mean you're gonna fail at everything. Keep trying, hold on, and always, always, always believe in yourself, because if you don't, then who will, sweetie? So keep your head high, keep your chin up, and most importantly, keep smiling, because life's a beautiful thing and there's so much to smile about.”",
        "author": "Marilyn Monroe",
        "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
        "tags": [
            "friends",
            "heartbreak",
            "inspirational",
            "life",
            "love",
            "sisters"
        ]
    },
    {
        "quote": "“You may not be her first, her last, or her only. She loved before she may love again. But if she loves you now, what else matters? She's not perfect—you aren't either, and the two of you may never be perfect together but if she can make you laugh, cause you to think twice, and admit to being human and making mistakes, hold onto her and give her the most you can. She may not be thinking about you every second of the day, but she will give you a part of her that she knows you can break—her heart. So don't hurt her, don't change her, don't analyze and don't expect more than she can give. Smile when she makes you happy, let her know when she makes you mad, and miss her when she's not there.”",
        "author": "Bob Marley",
        "author_about": "http://quotes.toscrape.com/author/Bob-Marley",
        "tags": [
            "love"
        ]
    },
    {
        "quote": "“The opposite of love is not hate, it's indifference. The opposite of art is not ugliness, it's indifference. The opposite of faith is not heresy, it's indifference. And the opposite of life is not death, it's indifference.”",
        "author": "Elie Wiesel",
        "author_about": "http://quotes.toscrape.com/author/Elie-Wiesel",
        "tags": [
            "activism",
            "apathy",
            "hate",
            "indifference",
            "inspirational",
            "love",
            "opposite",
            "philosophy"
        ]
    },
    {
        "quote": "“It is not a lack of love, but a lack of friendship that makes unhappy marriages.”",
        "author": "Friedrich Nietzsche",
        "author_about": "http://quotes.toscrape.com/author/Friedrich-Nietzsche",
        "tags": [
            "friendship",
            "lack-of-friendship",
            "lack-of-love",
            "love",
            "marriage",
            "unhappy-marriage"
        ]
    },
    {
        "quote": "“I love you without knowing how, or when, or from where. I love you simply, without problems or pride: I love you in this way because I do not know any other way of loving but this, in which there is no I or you, so intimate that your hand upon my chest is my hand, so intimate that when I fall asleep your eyes close.”",
        "author": "Pablo Neruda",
        "author_about": "http://quotes.toscrape.com/author/Pablo-Neruda",
        "tags": [
            "love",
            "poetry"
        ]
    },
    {
        "quote": "“If you can make a woman laugh, you can make her do anything.”",
        "author": "Marilyn Monroe",
        "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
        "tags": [
            "girls",
            "love"
        ]
    },
    {
        "quote": "“The real lover is the man who can thrill you by kissing your forehead or smiling into your eyes or just staring into space.”",
        "author": "Marilyn Monroe",
        "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
        "tags": [
            "love"
        ]
    },
    {
        "quote": "“Love does not begin and end the way we seem to think it does. Love is a battle, love is a war; love is a growing up.”",
        "author": "James Baldwin",
        "author_about": "http://quotes.toscrape.com/author/James-Baldwin",
        "tags": [
            "love"
        ]
    },
    {
        "quote": "“There is nothing I would not do for those who are really my friends. I have no notion of loving people by halves, it is not my nature.”",
        "author": "Jane Austen",
        "author_about": "http://quotes.toscrape.com/author/Jane-Austen",
        "tags": [
            "friendship",
            "love"
        ]
    }
]

```

4 - Com o token de acesso é possível listar todos os 'quotes' registrados no sistema. Para tal basta acessar o endpoint **localhost:3000/quotes**, informando mais uma vez o token de acesso e o retorno deverá se algo parecido com:

```
{
    "data": [
        {
            "id": "5c10404bd33ff80001e10e28",
            "type": "quotes",
            "attributes": {
                "quote": "“It is better to be hated for what you are than to be loved for what you are not.”",
                "author": "André Gide",
                "author_about": "http://quotes.toscrape.com/author/Andre-Gide",
                "tags": [
                    "life",
                    "love"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e29",
            "type": "quotes",
            "attributes": {
                "quote": "“This life is what you make it. No matter what, you're going to mess up sometimes, it's a universal truth. But the good part is you get to decide how you're going to mess it up. Girls will be your friends - they'll act like it anyway. But just remember, some come, some go. The ones that stay with you through everything - they're your true best friends. Don't let go of them. Also remember, sisters make the best friends in the world. As for lovers, well, they'll come and go too. And baby, I hate to say it, most of them - actually pretty much all of them are going to break your heart, but you can't give up because if you give up, you'll never find your soulmate. You'll never find that half who makes you whole and that goes for everything. Just because you fail once, doesn't mean you're gonna fail at everything. Keep trying, hold on, and always, always, always believe in yourself, because if you don't, then who will, sweetie? So keep your head high, keep your chin up, and most importantly, keep smiling, because life's a beautiful thing and there's so much to smile about.”",
                "author": "Marilyn Monroe",
                "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
                "tags": [
                    "friends",
                    "heartbreak",
                    "inspirational",
                    "life",
                    "love",
                    "sisters"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2a",
            "type": "quotes",
            "attributes": {
                "quote": "“You may not be her first, her last, or her only. She loved before she may love again. But if she loves you now, what else matters? She's not perfect—you aren't either, and the two of you may never be perfect together but if she can make you laugh, cause you to think twice, and admit to being human and making mistakes, hold onto her and give her the most you can. She may not be thinking about you every second of the day, but she will give you a part of her that she knows you can break—her heart. So don't hurt her, don't change her, don't analyze and don't expect more than she can give. Smile when she makes you happy, let her know when she makes you mad, and miss her when she's not there.”",
                "author": "Bob Marley",
                "author_about": "http://quotes.toscrape.com/author/Bob-Marley",
                "tags": [
                    "love"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2b",
            "type": "quotes",
            "attributes": {
                "quote": "“The opposite of love is not hate, it's indifference. The opposite of art is not ugliness, it's indifference. The opposite of faith is not heresy, it's indifference. And the opposite of life is not death, it's indifference.”",
                "author": "Elie Wiesel",
                "author_about": "http://quotes.toscrape.com/author/Elie-Wiesel",
                "tags": [
                    "activism",
                    "apathy",
                    "hate",
                    "indifference",
                    "inspirational",
                    "love",
                    "opposite",
                    "philosophy"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2c",
            "type": "quotes",
            "attributes": {
                "quote": "“It is not a lack of love, but a lack of friendship that makes unhappy marriages.”",
                "author": "Friedrich Nietzsche",
                "author_about": "http://quotes.toscrape.com/author/Friedrich-Nietzsche",
                "tags": [
                    "friendship",
                    "lack-of-friendship",
                    "lack-of-love",
                    "love",
                    "marriage",
                    "unhappy-marriage"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2d",
            "type": "quotes",
            "attributes": {
                "quote": "“I love you without knowing how, or when, or from where. I love you simply, without problems or pride: I love you in this way because I do not know any other way of loving but this, in which there is no I or you, so intimate that your hand upon my chest is my hand, so intimate that when I fall asleep your eyes close.”",
                "author": "Pablo Neruda",
                "author_about": "http://quotes.toscrape.com/author/Pablo-Neruda",
                "tags": [
                    "love",
                    "poetry"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2e",
            "type": "quotes",
            "attributes": {
                "quote": "“If you can make a woman laugh, you can make her do anything.”",
                "author": "Marilyn Monroe",
                "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
                "tags": [
                    "girls",
                    "love"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e2f",
            "type": "quotes",
            "attributes": {
                "quote": "“The real lover is the man who can thrill you by kissing your forehead or smiling into your eyes or just staring into space.”",
                "author": "Marilyn Monroe",
                "author_about": "http://quotes.toscrape.com/author/Marilyn-Monroe",
                "tags": [
                    "love"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e30",
            "type": "quotes",
            "attributes": {
                "quote": "“Love does not begin and end the way we seem to think it does. Love is a battle, love is a war; love is a growing up.”",
                "author": "James Baldwin",
                "author_about": "http://quotes.toscrape.com/author/James-Baldwin",
                "tags": [
                    "love"
                ]
            }
        },
        {
            "id": "5c10404bd33ff80001e10e31",
            "type": "quotes",
            "attributes": {
                "quote": "“There is nothing I would not do for those who are really my friends. I have no notion of loving people by halves, it is not my nature.”",
                "author": "Jane Austen",
                "author_about": "http://quotes.toscrape.com/author/Jane-Austen",
                "tags": [
                    "friendship",
                    "love"
                ]
            }
        }
    ]
}
```

### Soluções para o problema

Eu decidi atacar primeiramente o requisito de token de acesso ao sistema para isso decidi usar JWT como modelo de validação. Decidi colocar na ApplicationController toda minha lógica para validação, encoder e decoder do token, sei que essa não é a melhor prática mas a pressa me fez tomar essa decisão. Decidi colocar um tempo para o token permanecer válido de 4 horas, e a cada nova interação com o componente esse token é revalidado



```ruby
class ApplicationController < ActionController::API
  before_action :jwt_auth_validation
#
  def jwt_auth_validation
    if request.headers['Authentication'].present?
      token_decoded = jwt_decode(request.headers['Authentication'])

      if token_decoded.length > 1
        # jwt has been successfully decoded
        pswrc = token_decoded[0]['request_type'] == 'password_recovery'
        if jwt_invalid_payload(token_decoded[0])
          msg = 'Authentication error, invalid payload.'
          render json: { error: msg }, status: :unauthorized

        elsif !jwt_invalid_payload(token_decoded[0]) && pswrc
          # password recovery token verification
          fullpath = '/users/' + token_decoded[0]['user_id'].to_s
          unless request.original_fullpath.index(fullpath).zero?
            msg = 'Permission error, action unauthorized.'
            render json: { error: msg }, status: :unauthorized
          end
        end
      elsif token_decoded.length == 1
        # jwt hasn't been decoded
        if !token_decoded[0][:expired].nil? && token_decoded[0][:expired]
          msg = 'Authentication error, token has been expired.'
          render json: { error: msg }, status: :unauthorized
        end
        msg = 'Authentication error, token is wrong on header Authentication'
        render json: { error: msg }, status: :unauthorized
      end

      # renew token
      if token_decoded.length > 1
        renewed_payload = token_decoded.first

        if renewed_payload['exp'].present?
          time_start = Time.at(renewed_payload['exp']) - 1.hours
          time_end = Time.at(renewed_payload['exp'])
          time_now = Time.now.to_i

          if time_now >= time_start.to_i && time_now <= time_end.to_i
            renewed_payload['exp'] = 4.hours.from_now.to_i
            response.headers['JWT-Token-Renewed'] = jwt_encode(renewed_payload)
          end
        end
      end
    else
      msg = 'Authentication error, token is missing on header Authentication'
      render json: { error: msg }, status: :unauthorized
    end
  end
#
  private
#
  def jwt_decode(jwt_hash)
    algo = { algorithm: 'HS256' }
    JWT.decode jwt_hash, Rails.application.secrets.hmac_secret, true, algo
  rescue JWT::ExpiredSignature
    [{ expired: true }]
  rescue StandardError
    [{ invalid: true }]
  end
#
  def jwt_encode(payload = {})
    JWT.encode payload, Rails.application.secrets.hmac_secret, 'HS256'
  end

  def jwt_invalid_payload(payload)
    !payload['token_type'].present? || payload['token_type'].present? &&
      payload['token_type'] != 'client_a2'
  end
end

```

Outro ponto que devo destacar é a solução para o requisito de cache que foi pedido. Decidi usar o redis por ser mais amigável com o rails. A validação se dava mediante a uma busca no cache, caso já tenho algo com a tag que foi pesquisada previamente ele resgata do cache sendo mais rápido do que realizar uma nova busca. Caso não tenha sido pesquisada a tag ele segue para uma pesquisa realizando o crawler e retornando as informações registrando no cache para agilizar a próxima busca

```ruby

# POST /quotes/:tag
def search_quotes_by_tag
  quotes = $redis.get(params[:tag])
  if quotes.nil?
    quotes = Quote.crawler_data(params[:tag])
    puts quotes
    $redis.set(params[:tag], quotes)
    $redis.expire(params[:tag],2.hours.to_i)
  end
  render json: quotes
end

```
