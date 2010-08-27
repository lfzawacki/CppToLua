class Joystick {

		public:
			Joystick();
			Joystick(string joyname);

			~Joystick();
			bool isConfigured();
			void saveConfig();
			void loadConfig();
			void configureButtons();
			void mapButton(int action, int button);
			void printStatus();
			void receiveInput(int mask, int x, int y, int z);

			vector<int>  getAxes();
			vector<bool> getButtonsPressed();
			vector<int> getAll();
			//getters
			int getX();
			int getY();
			int getZ();
			int getMask();

			//setters
			void setX(int newx);
			void setY(int newy);
			void setZ(int newz);

		private:
			string name;
			int x,y,z;

			//cada ação está associada ao seu botão respectivo
			int buttonMapping[ACTIONS_TOTAL];
			//array das ações atuais;
			bool currentActions[ACTIONS_TOTAL];


			//Métodos Privados
			//retorna o índice de uma ação dada como uma string
			int getActionIndex(string action);
			//retorna o índice de um botão dado como uma string
			int getButtonIndex(string button);

			void printActions();
			void setAxes(int x, int y, int z);

};
