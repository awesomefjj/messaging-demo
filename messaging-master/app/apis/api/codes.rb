class API::Codes
  SUCCESS = 0
  UNKNOWN = -1

  CODE_DEFINES = {
    UNKNOWN => '未知错误',
    SUCCESS => '成功',
    401 => '授权失败',
    403 => '没有权限',
    404 => '找不到记录'
  }

  def self.[](v)
    CODE_DEFINES[v] || raise("Undefined API code #{v}")
  end
end
