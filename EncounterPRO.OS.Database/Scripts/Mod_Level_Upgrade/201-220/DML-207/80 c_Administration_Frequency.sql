
  UPDATE [c_Administration_Frequency]
  SET sort_sequence = 45 
  WHERE administer_frequency = 'ASDIR'

  UPDATE [c_Administration_Frequency]
  SET sort_sequence = 10 
  WHERE administer_frequency = 'BID'  

  UPDATE [c_Administration_Frequency]
  SET sort_sequence = 20 
  WHERE administer_frequency = 'QD'