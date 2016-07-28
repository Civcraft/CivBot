# Civbot

**For automated relay tasks and other cool stuff.**

## Installation & Usage

  1. Ensure [Elixir](http://elixir-lang.org/install.html) is installed.

  2. Edit `config/config.exs` to set slack bot key:

    ```elixir
    config :slack, api_token: "<key-here>"
    ```
  3. Compile the application:

    ```
    **WINDOWS(cmd):**
    set "MIX_ENV=prod" && mix compile
    **UNIX(bash)**
    MIX_ENV=prod mix compile
    ```
  4. Run the application:

    ```
    **WINDOWS(cmd):**
    set "MIX_ENV=prod" && iex --werl --no-halt -S mix
    **UNIX(bash)**
    MIX_ENV=prod iex --no-halt -S mix
    ```
