defmodule InnWeb.UserChannel do
use InnWeb, :channel

def join(name, _params, socket) do
 IO.puts("+++++++")
  IO.puts(name)
  {:ok, %{hey: "there"}, socket}
end

def handle_in(name, message, socket) do
  IO.puts("+++++++")
   IO.puts(name)
   IO.puts(message)
   {:reply, :ok, socket}
end


end
