extends Node

const HOST: String = "127.0.0.1"
const PORT: int = 7350
const SCHEME: String = "http"

var session: NakamaSession
var client: NakamaClient
var socket: NakamaSocket

var accountInfo: NakamaAPI.ApiAccount
var createMatch: NakamaAsyncResult

func _ready() -> void :

    pass

func Login(email: String, password: String) -> bool:
    session = await client.authenticate_email_async(email, password, null, false)

    socket = Nakama.create_socket_from(client)

    await socket.connect_async(session)

    if session.is_exception():
        BroadCastManager.BroadCastFloatCreate("LOGIN_FAILD")
        return false

    BroadCastManager.BroadCastFloatCreate("LOGIN_SUCCESS")
    socket.connected.connect(SockeyConnected)
    socket.closed.connect(SockeyClosed)
    socket.received_error.connect(SockeyReceivedError)

    socket.received_match_presence.connect(SockeyReceivedMatchPresence)
    socket.received_match_state.connect(SockeyReceivedMatchState)

    accountInfo = await client.get_account_async(session)

    CreateMatch("111")

    return true

func LogOut() -> bool:
    var result: NakamaAsyncResult = await client.session_logout_async(session)
    session = null
    socket = null
    return !result.is_exception()

func Regist(email: String = "", password: String = "", userName: String = "") -> bool:
    session = await client.authenticate_email_async(email, password, userName, true)

    socket = Nakama.create_socket_from(client)

    await socket.connect_async(session)

    if session.is_exception():
        BroadCastManager.BroadCastFloatCreate("REGIST_FAILD")
        return false

    BroadCastManager.BroadCastFloatCreate("REGIST_SUCCESS")

    await UpdateUserInfo(userName, userName)

    accountInfo = await client.get_account_async(session)

    return true

func IsConnect() -> bool:
    return false


func UpdateUserInfo(userName: String, displayName: String, avaterUrl: String = "", language: String = "zh", location: String = "cn", timezone: String = "cst") -> void :
    await client.update_account_async(session, userName, displayName, avaterUrl, language, location, timezone)

func GetUserName() -> String:
    return accountInfo.user.username

func GetUserDisplayName() -> String:
    return accountInfo.user.display_name

func SaveUserData(collision: String, key: String, data: String, canRead: bool, canWrite: bool) -> bool:
    var acks: NakamaAPI.ApiStorageObjectAcks = await client.write_storage_objects_async(session, [NakamaWriteStorageObject.new(collision, key, canRead, canWrite, data, "")])
    return !acks.is_exception()

func LoadUserData(collision: String, key: String) -> Variant:
    var readObjectId: NakamaStorageObjectId = NakamaStorageObjectId.new(collision, key, session.user_id)
    var result: NakamaAPI.ApiStorageObjects = await client.read_storage_objects_async(session, [readObjectId])
    if !result.objects:
        return null
    return JSON.parse_string(result.objects[0].value)

func CreateMatch(matchName: String) -> bool:
    createMatch = await socket.create_match_async(matchName)
    return !createMatch.is_exception()



func SockeyConnected() -> void :
    print("Socket Connected")

func SockeyClosed() -> void :
    print("Socket Closed")

func SockeyReceivedError(err) -> void :
    prints("Socket ReceivedError :", err)

func SockeyReceivedMatchPresence(presenece: NakamaRTAPI.MatchPresenceEvent) -> void :
    print(presenece)

func SockeyReceivedMatchState(state: NakamaRTAPI.MatchData) -> void :
    print(state)
