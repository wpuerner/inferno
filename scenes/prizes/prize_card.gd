extends Button

var prize:
	set(value):
		prize = value
		find_child("TitleLabel").text = prize.title
		if prize.image_path:
			find_child("TextureRect").texture = load(prize.image_path)
		elif prize.image_resource:
			find_child("TextureRect").texture = prize.image_resource
		find_child("DescriptionLabel").text = prize.description
