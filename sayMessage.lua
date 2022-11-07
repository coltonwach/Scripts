return function (Message, c, ...)
	Message = Message:format(...)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = Message,
		Color = c,
		FontSize = Enum.FontSize.Size96,
	})
end