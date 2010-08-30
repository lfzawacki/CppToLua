#ifndef _ROBOPET_POINT_H_
#define _ROBOPET_POINT_H_

#include "robopet.h"
#define square(x) ((x)*(x))

using RP::Point;

class Point
{
	    public:
		            Point() { setXY(0.0 ,0.0); }
			            Point(double valueX, double valueY) { setXY(valueX, valueY); }
				            Point (const Point &p) { setXY(p); }

					            ~Point() {}

						    		//----- Getters -----
								//		inline double getX() const { return _x; }
								//		        inline double getY() const { return _y; }
								//
								//		        		//----- Setters -----
								//		        		        void setX(double u);
								//		        		                void setY(double v);
								//		        		                        void setXY(double u, double v);
								//		        		                                void setXY(const Point &p);
								//
								//		        		                                        //----- Others -----
								//		        		                                                double getDistance(const Point &pos) const;
								//		        		                                                        double getDistanceX(const Point &pos) const;
								//		        		                                                                double getDistanceY(const Point &pos) const;
								//
								//		        		                                                                		/***************************************************************
								//		        		                                                                		        Operadores:
								//		        		                                                                		                ***************************************************************/
								//
								//		        		                                                                		                		Point& operator=(const Point &p);
								//		        		                                                                		                				//Point& operator=(Point p);
								//
								//		        		                                                                		                						bool operator>=(const Point &p) const;
								//		        		                                                                		                								bool operator<(const Point &p) const;
								//		        		                                                                		                								        bool operator==(const Point &p) const;
								//		        		                                                                		                								                bool operator!=(const Point &p) const;
								//		        		                                                                		                								                        Point operator+(const Point &p) const;
								//		        		                                                                		                								                                Point operator-(const Point &p) const;
								//		        		                                                                		                								                                		Point operator-() const;
								//
								//
								//		        		                                                                		                								                                			protected:
								//		        		                                                                		                								                                			        double _x;
								//		        		                                                                		                								                                			                double _y;
								//		        		                                                                		                								                                			                };
								//
								//		        		                                                                		                								                                			                #endif
								//
