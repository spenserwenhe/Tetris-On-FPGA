//state machine module
//states:Reset, game start, difficulty levels (3), LINE BREAK STATE, game over state
module control(input logic clk, reset, gameOver, lineBreak, fell, startGame,
			   output logic lineBreakMode, gameOverMode, spawnBlock
			   );

enum logic [5:0]{
    Wait,
	Reset,
	GameOver,//gameovermode==1 //from gameplay
	LineBreak, //linebreakmode ==1 //from gameplay state
	Spawn, //if fell==1 spawn new block
	spawnWait,
	Gameplay //comes right after spawn
} State, Next_state;

always_ff @ (posedge clk)
begin
    if (reset)
        State <= Reset;
    else
        State <= Next_state;
end

always_comb
begin
    Next_state = State;

    //default control signal values go here
    lineBreakMode = 1'b0;
    gameOverMode = 1'b0;
		spawnBlock = 1'b0;

    //assigning next state goes here
    unique case (State)
		Reset:
			Next_state = Wait;
        Wait:
            if (startGame) Next_state = Spawn;
        Spawn:
            Next_state = spawnWait;
			spawnWait:
				Next_state = Gameplay;
        Gameplay:
			begin
				if (lineBreak == 1) Next_state = LineBreak;
				if (fell == 1) Next_state = Spawn;
				if (gameOver == 1) Next_state = GameOver;
			end
		  LineBreak:
            Next_state = Gameplay;
        GameOver:
            Next_state = Wait;
        default : ;
	endcase

    case (State)
        Wait : ;
		  Spawn:
				begin
					spawnBlock = 1'b1;
				end
			spawnWait:
				begin
					spawnBlock = 1'b1;
				end
        LineBreak:
            begin
               lineBreakMode = 1'b1; 
            end
        GameOver:
            begin
                gameOverMode = 1'b1;
            end
		default : ;
	endcase
end

					
endmodule
