module BackupsHelper
  def human_status(backup)
    backup.current ? "<div class='current'>Current</div>" : "Archive"
  end
end
