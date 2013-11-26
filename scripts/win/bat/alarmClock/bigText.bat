@Echo off&SETLOCAL
IF [%1] NEQ [] goto s_start
Echo   Syntax  
Echo       BIGTEXT string
Echo           Where string is the text or numbers to be displayed
Echo:
GOTO :eof
   :s_start
      SET _length=0
      SET _sentence=%*

      :: Get the length of the sentence
      SET _substring=%_sentence%
   :s_loop
      IF not defined _substring GOTO :s_result
      ::remove the first char from _substring (until it is null)
      SET _substring=%_substring:~1%
      SET /A _length+=1
      GOTO s_loop
      
   :s_result
      SET /A _length-=1

      :: Truncate text to fit the window size
      :: assuming average char is 6 digits wide
      for /f "tokens=2" %%G in ('mode ^|find "Columns"') do set/a _window=%%G/6
      IF %_length% GTR %_window% set _length=%_window% 

      :: Step through each digit of the sentence and store in a set of variables
      FOR /L %%G IN (0,1,%_length%) DO call :s_build %%G
      
   :: Now Echo all the variables
   Echo:
   Echo %_1%
   Echo %_2%
   Echo %_3%
   Echo %_4%
   Echo %_5%
   Echo %_6%
   Echo %_7%
   Echo:
   GOTO :EOF

   :s_build
      :: get the next character
      CALL SET _digit=%%_sentence:~%1,1%%%
      :: Add the graphics for this digit to the variables
      IF "%_digit%"==" " (CALL :s_space) ELSE (CALL :s_%_digit%)
   GOTO :EOF
   
   ::  Pad digits to -->
   :s_0
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_1
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_2
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_3
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%    #)
      (SET _3=%_3%    #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_4
   ::  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   GOTO :EOF
   
   :s_5
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_6
   ::  Pad digits to -->
      (SET _1=%_1% ##  )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_7
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3%    #)
      (SET _4=%_4%   ##)
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7%   # )
   GOTO :EOF
   
   :s_8
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_9
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7%    #)
   GOTO :EOF
   
   :s_-
   ::  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4% ####)
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%     )
   GOTO :EOF
   
   :s_.
   ::  Pad digits to -->
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4%     )
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%  #  )
   GOTO :EOF
   
   :s_a
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF
   
   :s_b
   ::  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   GOTO :EOF
   
   :s_c
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF
   
   :s_d
   ::  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% ### )
   GOTO :EOF
   
   :s_e
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   GOTO :EOF
   
   :s_f
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   GOTO :EOF

   :s_g
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% # ##)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_h
   ::  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ####)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_i
   ::  Pad digits to -->
      (SET _1=%_1%  # )
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   GOTO :EOF

   :s_j
   ::  Pad digits to -->
      (SET _1=%_1% ####)
      (SET _2=%_2%   # )
      (SET _3=%_3%   # )
      (SET _4=%_4%   # )
      (SET _5=%_5%   # )
      (SET _6=%_6%   # )
      (SET _7=%_7% ##  )
   GOTO :EOF

   :s_k
   ::  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #  #)
      (SET _3=%_3% # # )
      (SET _4=%_4% ##  )
      (SET _5=%_5% ##  )
      (SET _6=%_6% # # )
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_l
   ::  Pad digits to -->
      (SET _1=%_1% #   )
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4% #   )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% ####)
   GOTO :EOF

   :s_m
   ::  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ## ##)
      (SET _3=%_3% # # #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #   #)
      (SET _6=%_6% #   #)
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_n
   ::  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% ##  #)
      (SET _3=%_3% ##  #)
      (SET _4=%_4% # # #)
      (SET _5=%_5% #  ##)
      (SET _6=%_6% #  ##)
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_o
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_p
   ::  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% #   )
      (SET _6=%_6% #   )
      (SET _7=%_7% #   )
   GOTO :EOF

   :s_q
   ::  Pad digits to -->
      (SET _1=%_1%  ## )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% # ##)
      (SET _7=%_7%  # #)
   GOTO :EOF

   :s_r
   ::  Pad digits to -->
      (SET _1=%_1% ### )
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% ### )
      (SET _5=%_5% # # )
      (SET _6=%_6% #  #)
      (SET _7=%_7% #  #)
   GOTO :EOF

   :s_s
   ::  Pad digits to -->
      (SET _1=%_1%  ###)
      (SET _2=%_2% #   )
      (SET _3=%_3% #   )
      (SET _4=%_4%  ## )
      (SET _5=%_5%    #)
      (SET _6=%_6%    #)
      (SET _7=%_7% ### )
   GOTO :EOF

   :s_t
   ::  Pad digits to -->
      (SET _1=%_1% ###)
      (SET _2=%_2%  # )
      (SET _3=%_3%  # )
      (SET _4=%_4%  # )
      (SET _5=%_5%  # )
      (SET _6=%_6%  # )
      (SET _7=%_7%  # )
   GOTO :EOF

   :s_u
   ::  Pad digits to -->
      (SET _1=%_1% #  #)
      (SET _2=%_2% #  #)
      (SET _3=%_3% #  #)
      (SET _4=%_4% #  #)
      (SET _5=%_5% #  #)
      (SET _6=%_6% #  #)
      (SET _7=%_7%  ## )
   GOTO :EOF

   :s_v
   ::  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2% #   #)
      (SET _3=%_3% #   #)
      (SET _4=%_4% #   #)
      (SET _5=%_5% #   #)
      (SET _6=%_6%  # # )
      (SET _7=%_7%   #  )
   GOTO :EOF

   :s_w
   ::  Pad digits to ----->
      (SET _1=%_1% #  #  #)
      (SET _2=%_2% #  #  #)
      (SET _3=%_3% #  #  #)
      (SET _4=%_4% #  #  #)
      (SET _5=%_5% #  #  #)
      (SET _6=%_6% #  #  #)
      (SET _7=%_7%  ## ## )
   GOTO :EOF

   :s_x
   ::  Pad digits to -->
      (SET _1=%_1%      )
      (SET _2=%_2% #   #)
      (SET _3=%_3%  # # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%  # # )
      (SET _7=%_7% #   #)
   GOTO :EOF

   :s_y
   ::  Pad digits to --->
      (SET _1=%_1% #   #)
      (SET _2=%_2%  # # )
      (SET _3=%_3%   #  )
      (SET _4=%_4%   #  )
      (SET _5=%_5%   #  )
      (SET _6=%_6%   #  )
      (SET _7=%_7%   #  )
   GOTO :EOF

   :s_z
   ::  Pad digits to --->
      (SET _1=%_1% #####)
      (SET _2=%_2%     #)
      (SET _3=%_3%    # )
      (SET _4=%_4%   #  )
      (SET _5=%_5%  #   )
      (SET _6=%_6% #    )
      (SET _7=%_7% #####)
   GOTO :EOF

   :s_space
   ::  Pad digits to --->
      (SET _1=%_1%      )
      (SET _2=%_2%      )
      (SET _3=%_3%      )
      (SET _4=%_4%      )
      (SET _5=%_5%      )
      (SET _6=%_6%      )
      (SET _7=%_7%      )
   GOTO :EOF

   ::  Pad digits to -->
   :s_!
      (SET _1=%_1% #)
      (SET _2=%_2% #)
      (SET _3=%_3% #)
      (SET _4=%_4% #)
      (SET _5=%_5% #)
      (SET _6=%_6%  )
      (SET _7=%_7% #)
   GOTO :EOF   
   
   ::  Pad digits to -->
   :s_:
      (SET _1=%_1%  )
      (SET _2=%_2% #)
      (SET _3=%_3% #)
      (SET _4=%_4%  )
      (SET _5=%_5% #)
      (SET _6=%_6% #)
      (SET _7=%_7%  )
   GOTO :EOF   

   ::  Pad digits to -->
   :s_/
      (SET _1=%_1%       # )
      (SET _2=%_2%      #  )
      (SET _3=%_3%     #   )
      (SET _4=%_4%    #    )
      (SET _5=%_5%   #     )
      (SET _6=%_6%  #      )
      (SET _7=%_7% #       )
   GOTO :EOF   

   ::  Pad digits to -->
   :s_-
      (SET _1=%_1%     )
      (SET _2=%_2%     )
      (SET _3=%_3%     )
      (SET _4=%_4% ####)
      (SET _5=%_5%     )
      (SET _6=%_6%     )
      (SET _7=%_7%     )
   GOTO :EOF   
   
   ::  Pad digits to -->
   :s__
      (SET _1=%_1%       )
      (SET _2=%_2%       )
      (SET _3=%_3%       )
      (SET _4=%_4%       )
      (SET _5=%_5%       )
      (SET _6=%_6%       )
      (SET _7=%_7% ######)
   GOTO :EOF    
   
   ::  Pad digits to -->
   :s_,
      (SET _1=%_1%   )
      (SET _2=%_2%   )
      (SET _3=%_3%   )
      (SET _4=%_4%   )
      (SET _5=%_5% ##)
      (SET _6=%_6% ##)
      (SET _7=%_7% # )
   GOTO :EOF    
   