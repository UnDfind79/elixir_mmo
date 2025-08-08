defmodule Mythweave.Admin.AdminHandler do
  @moduledoc """
  Handles slash admin commands for real-time inspection, moderation,
  and debugging of the Mythweave server.

  Responsibilities:
    - Parse and dispatch admin commands
    - Enforce admin authorization
    - Trigger in-game actions (kick, teleport, inspect, etc.)
    - Log all admin interventions via audit trail
  """

  alias Mythweave.Player.Registry, as: PlayerRegistry
  alias Mythweave.Logging.AuditLog
  alias Mythweave.Engine.EventBus

  @admin_commands %{
    "/kick" => &__MODULE__.kick_player/2,
    "/zone" => &__MODULE__.teleport_to_zone/3,
    "/inspect" => &__MODULE__.inspect_player/2,
    "/broadcast" => &__MODULE__.broadcast_message/2
  }

  @type player_id :: String.t()
  @type command_string :: String.t()

  @spec handle_command(player_id(), command_string()) :: {:ok, any()} | {:error, any()}
  def handle_command(sender_id, raw_command) do
    with {:ok, [cmd | args]} <- parse_command(raw_command),
         true <- is_admin?(sender_id),
         {:ok, result} <- dispatch_command(cmd, sender_id, args) do
      {:ok, result}
    else
      false -> {:error, :unauthorized}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec parse_command(command_string()) :: {:ok, [String.t()]} | {:error, atom()}
  defp parse_command(command) do
    parts = String.split(command)
    if String.starts_with?(hd(parts), "/"), do: {:ok, parts}, else: {:error, :not_a_command}
  end

  @spec dispatch_command(String.t(), player_id(), [String.t()]) :: {:ok, any()} | {:error, atom()}
  defp dispatch_command(cmd, sender_id, args) do
    case Map.get(@admin_commands, cmd) do
      nil -> {:error, :unknown_command}
      handler -> apply_handler(handler, sender_id, args)
    end
  end

  defp apply_handler(fun, sender_id, args) do
    try do
      case apply(fun, [sender_id | args]) do
        {:ok, _} = result -> result
        {:error, _} = error -> error
        other -> {:ok, other}
      end
    rescue
      _ -> {:error, :invalid_arguments}
    end
  end

  @spec is_admin?(player_id()) :: boolean()
  defp is_admin?(player_id), do: player_id in ["admin", "gm", "mod"]

  @spec kick_player(player_id(), player_id()) :: {:ok, String.t()} | {:error, String.t()}
  def kick_player(_sender, target_id) do
    case PlayerRegistry.lookup(target_id) do
      {:ok, pid} ->
        Process.exit(pid, :kick)
        AuditLog.record(:admin_action, "Kicked player #{target_id}")
        {:ok, "Player #{target_id} kicked."}

      _ -> {:error, "Player not found"}
    end
  end

  @spec teleport_to_zone(player_id(), player_id(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def teleport_to_zone(_sender, target_id, zone_id) do
    case PlayerRegistry.lookup(target_id) do
      {:ok, pid} ->
        send(pid, {:teleport, zone_id})
        AuditLog.record(:admin_action, "Teleported #{target_id} to #{zone_id}")
        {:ok, "Teleporting #{target_id} to #{zone_id}."}

      _ -> {:error, "Player not found"}
    end
  end

  @spec inspect_player(player_id(), player_id()) :: {:ok, String.t()} | {:error, String.t()}
  def inspect_player(_sender, target_id) do
    case PlayerRegistry.lookup(target_id) do
      {:ok, pid} ->
        state = :sys.get_state(pid)
        {:ok, inspect(state, pretty: true)}

      _ -> {:error, "Player not found"}
    end
  end

  @spec broadcast_message(player_id(), String.t()) :: {:ok, String.t()}
  def broadcast_message(_sender, message) do
    EventBus.broadcast(:system, {:broadcast, message})
    AuditLog.record(:admin_action, "Broadcasted: #{message}")
    {:ok, "Broadcast sent."}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Authorization is basic
  #    - ✅ Upgrade to dynamic claims-based permissions
  #
  # 2. Error feedback is minimal
  #    - 🚧 Add reason codes for all command errors
  #
  # 3. Logging is passive
  #    - ❗ Optionally notify admins of audit trail events in-game

end
