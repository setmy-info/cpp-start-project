#ifndef SET_MY_INFO_APPLICATION_HPP_
#define SET_MY_INFO_APPLICATION_HPP_

namespace SetMyInfo {

class Application {
public:
	Application();
	virtual ~Application();
	Application(const Application &other);
	Application(Application &&other);
	Application& operator=(const Application &other);
	Application& operator=(Application &&other);
};

} // namespace SetMyInfo

#endif // SET_MY_INFO_APPLICATION_HPP_
